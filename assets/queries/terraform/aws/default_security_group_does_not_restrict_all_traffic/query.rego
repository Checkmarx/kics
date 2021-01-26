package Cx

CxPolicy[result] {
	sg := input.document[i].resource.aws_default_security_group[name]
	checkCidrBlock(sg)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_default_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ingress.cidr_blocks or egress.cidr_blocks diferent from '0.0.0.0/0' ",
		"keyActualValue": "ingress.cidr_blocks or egress.cidr_blocks are '0.0.0.0/0'",
	}
}

CxPolicy[result] {
	sg := input.document[i].resource.aws_default_security_group[name]
	checkIpv6CidrBlock(sg)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_default_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ingress.ipv6_cidr_blocks or egress.ipv6_cidr_blocks diferent from '::/0' ",
		"keyActualValue": "ingress.ipv6_cidr_blocks or egress.ipv6_cidr_blocks are '::/0'",
	}
}

checkCidrBlock(sg) {
	some c
	sg.ingress.cidr_blocks[c] == "0.0.0.0/0"
}

checkCidrBlock(sg) {
	some c
	sg.egress.cidr_blocks[c] == "0.0.0.0/0"
}

checkIpv6CidrBlock(sg) {
	some c
	sg.egress.ipv6_cidr_blocks[c] == "::/0"
}

checkIpv6CidrBlock(sg) {
	some c
	sg.ingress.ipv6_cidr_blocks[c] == "::/0"
}
