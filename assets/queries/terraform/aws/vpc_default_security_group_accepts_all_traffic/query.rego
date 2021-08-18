package Cx

import data.generic.common as common_lib

blocks := {"ingress", "egress"}

CxPolicy[result] {
	resource := input.document[i].resource.aws_default_security_group[name]

	common_lib.valid_key(resource, "vpc_id")
	block := blocks[b]
	common_lib.valid_key(resource, block)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_default_security_group[{{%s}}].%s", [name, block]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_default_security_group[{{%s}}] does not have '%s' defined", [name, block]),
		"keyActualValue": sprintf("aws_default_security_group[{{%s}}] has '%s' defined", [name, block]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_default_security_group[name]

	common_lib.valid_key(resource, "vpc_id")

	block := blocks[b]
	cidrs := {"cidr_blocks", "ipv6_cidr_blocks"}
	acceptAll := {"0.0.0.0/0", "::/0"}

	resource[block][_][cidrs[c]][_] == acceptAll[a]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_default_security_group[{{%s}}].%s.%s", [name, block, cidrs[c]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' is undefined", [block]),
		"keyActualValue": sprintf("'%s' accepts all traffic", [block]),
	}
}
