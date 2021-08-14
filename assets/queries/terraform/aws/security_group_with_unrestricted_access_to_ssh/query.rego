package Cx

import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	terra_lib.openPort(resource.ingress, 22)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s].ingress.cidr_blocks", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) is not public", [name]),
		"keyActualValue": sprintf("aws_security_group[%s] 'SSH' (Port:22) is public", [name]),
	}
}
