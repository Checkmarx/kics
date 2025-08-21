package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib


# Case of aws_security_group_rule or aws_vpc_security_group_ingress_rule

CxPolicy[result] {
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	rule := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],rule)

	results := rule_is_unrestricted(types[i2],rule,name)
	results != ""

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


rule_is_unrestricted("aws_vpc_security_group_ingress_rule",rule,name) = results {
	rule.cidr_ipv4 == "0.0.0.0/0"
	results := {
		"searchKey" : sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4", [name]),
		"keyExpectedValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4 should not be equal to '0.0.0.0/0'", [name]),   
		"keyActualValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4 is equal to '0.0.0.0/0'", [name]),   
		"field": "cidr_ipv4"
	}
} else = results {
	rule.cidr_ipv6 == tf_lib.unrestricted_ipv6[l]
	results := {
		"searchKey" : sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv6", [name]),
		"keyExpectedValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv6 should not be equal to '%s'", [name,tf_lib.unrestricted_ipv6[l]]),   
		"keyActualValue": sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv6 is equal to '%s'", [name,tf_lib.unrestricted_ipv6[l]]),   
		"field": "cidr_ipv6"
	}
} else = ""

rule_is_unrestricted("aws_security_group_rule",rule,name) = results {
	contains(rule.cidr_blocks[j], "0.0.0.0/0")
	results := {
		"searchKey" : sprintf("aws_security_group_rule[%s].cidr_blocks", [name]),
		"keyExpectedValue": sprintf("aws_security_group_rule[%s].cidr_blocks' should not contain '0.0.0.0/0'",[name]),
		"keyActualValue": sprintf("aws_security_group_rule[%s].cidr_blocks' contains '0.0.0.0/0'",[name]),
		"field": "cidr_blocks"
	}
} else = results {
	contains(rule.ipv6_cidr_blocks[j], tf_lib.unrestricted_ipv6[l])
	results := {
		"searchKey": sprintf("aws_security_group_rule[%s].ipv6_cidr_blocks", [name]),
		"keyExpectedValue": sprintf("aws_security_group_rule[%s].ipv6_cidr_blocks should not contain '%s'",[name,tf_lib.unrestricted_ipv6[l]]),
		"keyActualValue": sprintf("aws_security_group_rule[%s].ipv6_cidr_blocks contains '%s'",[name,tf_lib.unrestricted_ipv6[l]]),
		"field": "ipv6_cidr_blocks"
	} 
} else = ""


#Case of aws_security_group
CxPolicy[result] {
	#Single Ingress 
	ingrs := input.document[i].resource.aws_security_group[name].ingress

	some j
	contains(ingrs.cidr_blocks[j], "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_security_group[name], name),
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress.cidr_blocks should not contain '0.0.0.0/0'", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress.cidr_blocks contains '0.0.0.0/0'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", "cidr_blocks"], []),
	}
}

CxPolicy[result] {
	#Single Ingress and IPV6
	ingrs := input.document[i].resource.aws_security_group[name].ingress

	some j
	contains(ingrs.ipv6_cidr_blocks[j], tf_lib.unrestricted_ipv6[l])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_security_group[name], name),
		"searchKey": sprintf("aws_security_group[%s].ingress.ipv6_cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress.ipv6_cidr_blocks should not contain '%s'", [name,tf_lib.unrestricted_ipv6[l]]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress.ipv6_cidr_blocks contains '%s'", [name,tf_lib.unrestricted_ipv6[l]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", "ipv6_cidr_blocks"], []),
	}
}


CxPolicy[result] {
	#Case of Ingress Array
	ingrs := input.document[i].resource.aws_security_group[name].ingress[i2]
	contains(ingrs.cidr_blocks[idx], "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_security_group[name], name),
		"searchKey": sprintf("aws_security_group[%s].ingress[%d].cidr_blocks", [name,i2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d].cidr_blocks should not contain '0.0.0.0/0'", [name,i2]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d].cidr_blocks contains '0.0.0.0/0'", [name,i2]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2, "cidr_blocks"], []),
	}
}

CxPolicy[result] {
	#Case of Ingress Array and IPV6
	ingrs := input.document[i].resource.aws_security_group[name].ingress[i2]
	contains(ingrs.ipv6_cidr_blocks[idx], tf_lib.unrestricted_ipv6[l])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_security_group[name], name),
		"searchKey": sprintf("aws_security_group[%s].ingress[%d].ipv6_cidr_blocks", [name,i2]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress[%d].ipv6_cidr_blocks should not contain '%s'", [name,i2,tf_lib.unrestricted_ipv6[l]]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress[%d].ipv6_cidr_blocks contains '%s'", [name,i2,tf_lib.unrestricted_ipv6[l]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", i2, "ipv6_cidr_blocks"], []),
	}
}
















# modules 

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group_rule", "ingress_ipv6_cidr_blocks") # based on module terraform-aws-modules/security-group/aws

	cidr := module[keyToCheck][idxCidr]
	contains(cidr, tf_lib.unrestricted_ipv6[l])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].%s should not contain '%s'", [name, keyToCheck, tf_lib.unrestricted_ipv6[l]]),
		"keyActualValue": sprintf("module[%s].%s contains '%s'", [name, keyToCheck, tf_lib.unrestricted_ipv6[l]]),
		"searchLine": common_lib.build_search_line(["module", name, "ingress_ipv6_cidr_blocks", idxCidr], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group_rule", "ingress_cidr_blocks") # based on module terraform-aws-modules/security-group/aws

	cidr := module[keyToCheck][idxCidr]
	contains(cidr, "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].%s should not contain '0.0.0.0/0'", [name, keyToCheck]),
		"keyActualValue": sprintf("module[%s].%s contains '0.0.0.0/0'", [name, keyToCheck]),
		"searchLine": common_lib.build_search_line(["module", name, "ingress_cidr_blocks", idxCidr], []),
	}
}
