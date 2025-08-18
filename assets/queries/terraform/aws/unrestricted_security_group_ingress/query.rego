package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# aws_security_group_rule and aws_vpc_security_group_ingress_rule

CxPolicy[result] {
	#ipv4
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	rule := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],rule)

	results := rule_is_unrestricted(types[i2],"ipv4",rule,name)
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


CxPolicy[result] {
	#ipv6
	types := ["aws_vpc_security_group_ingress_rule","aws_security_group_rule"]
	rule := input.document[i].resource[types[i2]][name]

	tf_lib.is_security_group_ingress(types[i2],rule)
	
	results := rule_is_unrestricted(types[i2],"ipv6",rule,name)
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


rule_is_unrestricted("aws_vpc_security_group_ingress_rule","ipv4",rule,name) = results {
	rule.cidr_ipv4 == "0.0.0.0/0"
	results := {
		"searchKey" : sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv4", [name]),
		"keyExpectedValue": "One of 'rule.cidr_ipv4' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'rule.cidr_ipv4' is equal '0.0.0.0/0'",
		"field": "cidr_ipv4"
	}
} else = ""

rule_is_unrestricted("aws_vpc_security_group_ingress_rule","ipv6",rule,name) = results {
	rule.cidr_ipv6 == tf_lib.unrestricted_ipv6[_]
	results := {
		"searchKey" : sprintf("aws_vpc_security_group_ingress_rule[%s].cidr_ipv6", [name]),
		"keyExpectedValue": "One of 'rule.cidr_ipv6' should not be equal to '::/0'",
		"keyActualValue": "One of 'rule.cidr_ipv6' is equal '::/0'",
		"field": "cidr_ipv6"
	}
} else = ""

rule_is_unrestricted("aws_security_group_rule","ipv4",rule,name) = results {
	contains(rule.cidr_blocks[j], "0.0.0.0/0")
	results := {
		"searchKey" : sprintf("aws_security_group_rule[%s].cidr_blocks", [name]),
		"keyExpectedValue": "One of 'rule.cidr_blocks' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'rule.cidr_blocks' is equal '0.0.0.0/0'",
		"field": "cidr_blocks"
	}
} else = ""

rule_is_unrestricted("aws_security_group_rule","ipv6",rule,name) = results {
	contains(rule.ipv6_cidr_blocks[j], tf_lib.unrestricted_ipv6[l])
	results := {
		"searchKey": sprintf("aws_security_group_rule[%s].ipv6_cidr_blocks", [name]),
		"keyExpectedValue": "One of 'rule.ipv6_cidr_blocks' should not be equal to '::/0'",
		"keyActualValue": "One of 'rule.ipv6_cidr_blocks' is equal '::/0'",
		"field": "ipv6_cidr_blocks"
	} 
} else = ""

# aws_security_group

CxPolicy[result] {
	#Case of Single Ingress 
	ingrs := input.document[i].resource.aws_security_group[name].ingress

	some j
	contains(ingrs.cidr_blocks[j], "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_security_group[name], name),
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'ingress.cidr_blocks' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'ingress.cidr_blocks' equal '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group_rule", name, "ingress", "cidr_blocks"], []),
	}
}

CxPolicy[result] {
	#Case of Single Ingress  and IPV6
	ingrs := input.document[i].resource.aws_security_group[name].ingress

	some j
	contains(ingrs.ipv6_cidr_blocks[j], tf_lib.unrestricted_ipv6[l])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_security_group[name], name),
		"searchKey": sprintf("aws_security_group[%s].ingress.ipv6_cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'ingress.ipv6_cidr_blocks' should not be equal to '::/0'",
		"keyActualValue": "One of 'ingress.ipv6_cidr_blocks' is equal '::/0'",
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group_rule", name, "ingress", "ipv6_cidr_blocks"], []),
	}
}


CxPolicy[result] {
	#Case of Ingress Array
	ingrs := input.document[i].resource.aws_security_group[name].ingress[j]
	contains(ingrs.cidr_blocks[idx], "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_security_group[name], name),
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'ingress.cidr_blocks' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'ingress.cidr_blocks' equal '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", j, "cidr_blocks", idx], []),
	}
}




CxPolicy[result] {
	#Case of Ingress Array and IPV6
	ingrs := input.document[i].resource.aws_security_group[name].ingress[j]
	contains(ingrs.ipv6_cidr_blocks[idx], tf_lib.unrestricted_ipv6[l])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_security_group",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_security_group[name], name),
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'ingress.ipv6_cidr_blocks' should not be equal to '::/0'",
		"keyActualValue": "One of 'ingress.ipv6_cidr_blocks' is equal '::/0'",
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", j, "ipv6_cidr_blocks", idx], []),
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
		"keyExpectedValue": "One of 'ingress.ipv6_cidr_blocks' should not be equal to '::/0'",
		"keyActualValue": "One of 'ingress.ipv6_cidr_blocks' is equal '::/0'",
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
		"keyExpectedValue": "One of 'ingress.cidr_blocks' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'ingress.cidr_blocks' equal '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["module", name, "ingress_cidr_blocks", idxCidr], []),
	}
}
