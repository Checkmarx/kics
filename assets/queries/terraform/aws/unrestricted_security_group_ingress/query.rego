package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	rule := input.document[i].resource.aws_security_group_rule[name]

	lower(rule.type) == "ingress"
	some j
	contains(rule.cidr_blocks[j], "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group_rule[%s].cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'rule.cidr_blocks' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'rule.cidr_blocks' is equal '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group_rule", name, "cidr_blocks"], []),
	}
}

CxPolicy[result] {
	ingrs := input.document[i].resource.aws_security_group[name].ingress

	some j
	contains(ingrs.cidr_blocks[j], "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'ingress.cidr_blocks' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'ingress.cidr_blocks' equal '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group_rule", name, "ingress", "cidr_blocks"], []),
	}
}

CxPolicy[result] {
	ingrs := input.document[i].resource.aws_security_group[name].ingress[j]
	contains(ingrs.cidr_blocks[idx], "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'ingress.cidr_blocks' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'ingress.cidr_blocks' equal '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["resource", "aws_security_group", name, "ingress", j, "cidr_blocks", idx], []),
	}
}

# rule for modules
CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_security_group_rule", "ingress_cidr_blocks") # based on module terraform-aws-modules/security-group/aws

	cidr := module[keyToCheck][idxCidr]
	contains(cidr, "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'ingress.cidr_blocks' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'ingress.cidr_blocks' equal '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["module", name, "ingress_cidr_blocks", idxCidr], []),
	}
}
