package Cx

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
	}
}

CxPolicy[result] {
	ingrs := input.document[i].resource.aws_security_group[name].ingress[_]

	some j
	contains(ingrs.cidr_blocks[j], "0.0.0.0/0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "One of 'ingress.cidr_blocks' not equal '0.0.0.0/0'",
		"keyActualValue": "One of 'ingress.cidr_blocks' equal '0.0.0.0/0'",
	}
}
