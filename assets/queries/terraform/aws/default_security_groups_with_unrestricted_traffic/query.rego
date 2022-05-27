package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	sg := input.document[i].resource.aws_default_security_group[name]
	checkCidrBlock(sg)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_security_group",
		"resourceName": tf_lib.get_resource_name(sg, name),
		"searchKey": sprintf("aws_default_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "ingress.cidr_blocks or egress.cidr_blocks diferent from '0.0.0.0/0' and '::/0'",
		"keyActualValue": "ingress.cidr_blocks or egress.cidr_blocks are equal to '0.0.0.0/0' or '::/0'",
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

checkCidrBlock(sg) {
	some c
	sg.egress.ipv6_cidr_blocks[c] == "::/0"
}

checkCidrBlock(sg) {
	some c
	sg.ingress.ipv6_cidr_blocks[c] == "::/0"
}
