package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	#Case of "aws_vpc_security_group_ingress_rule" or "aws_security_group_rule"
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	rule := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],rule)

	results := rule_is_unrestricted(types[i2],rule,name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(rule, name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": common_lib.build_search_line(["resource", types[i2], name, results.field], []),
	}
}

CxPolicy[result] {
	#Case of "aws_security_group"
	resource := input.document[i].resource.aws_security_group[name]

	ingress_list := tf_lib.get_ingress_list(resource.ingress)
	results := is_unrestricted_ingress(ingress_list.value[i2],ingress_list.is_unique_element,name,i2)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
	}
}

CxPolicy[result] {
	#Case of "security-group" Module
	module := input.document[i].module[name]
	types := ["ingress_cidr_blocks","ingress_ipv6_cidr_blocks","ingress_with_cidr_blocks","ingress_with_ipv6_cidr_blocks"]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group_rule", types[i2]) # based on module terraform-aws-modules/security-group/aws

	object_list := tf_lib.get_ingress_list(module[keyToCheck])
	cidr_or_ingress := object_list.value[i3]
	results := check_cidr_block(cidr_or_ingress,name,types[i2],keyToCheck,i3)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

# "aws_vpc_security_group_ingress_rule"
rule_is_unrestricted("aws_vpc_security_group_ingress_rule",rule,name) = results {
	rule.cidr_ipv4 == "0.0.0.0/0"
	results := {
		"searchKey" : sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4", [name]),
		"keyExpectedValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4 should not be equal to '0.0.0.0/0'", [name]),
		"keyActualValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4 is equal to '0.0.0.0/0'", [name]),
		"field": "cidr_ipv4"
	}
} else = results {
	rule.cidr_ipv6 == common_lib.unrestricted_ipv6[l]
	results := {
		"searchKey" : sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv6", [name]),
		"keyExpectedValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv6 should not be equal to '%s'", [name, common_lib.unrestricted_ipv6[l]]),   
		"keyActualValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv6 is equal to '%s'", [name, common_lib.unrestricted_ipv6[l]]),   
		"field": "cidr_ipv6"
	}
}

# "aws_security_group_rule"
rule_is_unrestricted("aws_security_group_rule",rule,name) = results {
	contains(rule.cidr_blocks[_], "0.0.0.0/0")
	results := {
		"searchKey" : sprintf("aws_security_group_rule[%s].cidr_blocks", [name]),
		"keyExpectedValue": sprintf("aws_security_group_rule[%s].cidr_blocks' should not contain '0.0.0.0/0'",[name]),
		"keyActualValue": sprintf("aws_security_group_rule[%s].cidr_blocks' contains '0.0.0.0/0'",[name]),
		"field": "cidr_blocks"
	}
} else = results {
	contains(rule.ipv6_cidr_blocks[_], common_lib.unrestricted_ipv6[l])
	results := {
		"searchKey": sprintf("aws_security_group_rule[%s].ipv6_cidr_blocks", [name]),
		"keyExpectedValue": sprintf("aws_security_group_rule[%s].ipv6_cidr_blocks should not contain '%s'",[name,common_lib.unrestricted_ipv6[l]]),
		"keyActualValue": sprintf("aws_security_group_rule[%s].ipv6_cidr_blocks contains '%s'",[name,common_lib.unrestricted_ipv6[l]]),
		"field": "ipv6_cidr_blocks"
	}
}

# "aws_security_group"
is_unrestricted_ingress(ingress,is_unique_element,name,i2) = results {
	#ipv4 single ingress
	is_unique_element
	contains(ingress.cidr_blocks[_], "0.0.0.0/0")

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress.cidr_blocks should not contain '0.0.0.0/0'", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress.cidr_blocks contains '0.0.0.0/0'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", "cidr_blocks"], []),
	}
} else = results {
	#ipv6 single ingress
	is_unique_element
	contains(ingress.ipv6_cidr_blocks[_], common_lib.unrestricted_ipv6[l])

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress.ipv6_cidr_blocks", [name]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress.ipv6_cidr_blocks should not contain '%s'", [name,common_lib.unrestricted_ipv6[l]]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress.ipv6_cidr_blocks contains '%s'", [name,common_lib.unrestricted_ipv6[l]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", "ipv6_cidr_blocks"], []),
	}
} else = results {
	#ipv4 ingress array
	not is_unique_element
	contains(ingress.cidr_blocks[_], "0.0.0.0/0")

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress[%d].cidr_blocks", [name,i2]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d].cidr_blocks should not contain '0.0.0.0/0'", [name,i2]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d].cidr_blocks contains '0.0.0.0/0'", [name,i2]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2, "cidr_blocks"], []),
	}
} else = results {
	#ipv6 ingress array
	not is_unique_element
	contains(ingress.ipv6_cidr_blocks[_], common_lib.unrestricted_ipv6[l])

	results := {
		"searchKey": sprintf("aws_security_group[%s].ingress[%d].ipv6_cidr_blocks", [name,i2]),
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d].ipv6_cidr_blocks should not contain '%s'", [name,i2,common_lib.unrestricted_ipv6[l]]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d].ipv6_cidr_blocks contains '%s'", [name,i2,common_lib.unrestricted_ipv6[l]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2, "ipv6_cidr_blocks"], []),
	}
}

# "security-group" Module
check_cidr_block(cidr_or_ingress,name,type,keyToCheck,i3) = results {
	#ipv4 inside ingress
	type == "ingress_with_cidr_blocks"
	common_lib.inArray(cidr_or_ingress.cidr_blocks, "0.0.0.0/0")
	results := {
		"keyExpectedValue": sprintf("module[%s].%s[%d].cidr_blocks should not contain '0.0.0.0/0'", [name, keyToCheck, i3]),
		"keyActualValue": sprintf("module[%s].%s[%d].cidr_blocks contains '0.0.0.0/0'", [name, keyToCheck, i3]),
		"searchKey" : sprintf("module[%s].%s[%d].cidr_blocks", [name, keyToCheck, i3]),
		"searchLine" : common_lib.build_search_line(["module", name, keyToCheck, i3, "cidr_blocks"], []),
	}
} else = results {
	#ipv6 inside ingress
	type == "ingress_with_ipv6_cidr_blocks"
	common_lib.inArray(cidr_or_ingress.ipv6_cidr_blocks, common_lib.unrestricted_ipv6[l])
	results := {
		"keyExpectedValue": sprintf("module[%s].%s[%d].ipv6_cidr_blocks should not contain '%s'", [name, keyToCheck, i3, common_lib.unrestricted_ipv6[l]]),
		"keyActualValue": sprintf("module[%s].%s[%d].ipv6_cidr_blocks contains '%s'", [name, keyToCheck, i3, common_lib.unrestricted_ipv6[l]]),
		"searchKey" : sprintf("module[%s].%s[%d].ipv6_cidr_blocks", [name, keyToCheck, i3]),
		"searchLine" : common_lib.build_search_line(["module", name, keyToCheck, i3, "ipv6_cidr_blocks"], []),
	}
} else = results {
	#direct ipv4
	type == "ingress_cidr_blocks"
	cidr_or_ingress == "0.0.0.0/0"
	results := {
		"keyExpectedValue": sprintf("module[%s].%s should not contain '0.0.0.0/0'", [name, keyToCheck]),
		"keyActualValue": sprintf("module[%s].%s contains '0.0.0.0/0'", [name, keyToCheck]),
		"searchKey" : sprintf("module[%s].%s", [name, keyToCheck]),
		"searchLine" : common_lib.build_search_line(["module", name, keyToCheck], []),
	}
} else = results {
	#direct ipv6
	type == "ingress_ipv6_cidr_blocks"
	cidr_or_ingress == common_lib.unrestricted_ipv6[l]
	results := {
		"keyExpectedValue": sprintf("module[%s].%s should not contain '%s'", [name, keyToCheck, common_lib.unrestricted_ipv6[l]]),
		"keyActualValue": sprintf("module[%s].%s contains '%s'", [name, keyToCheck, common_lib.unrestricted_ipv6[l]]),
		"searchKey" : sprintf("module[%s].%s", [name, keyToCheck]),
		"searchLine" : common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}
