package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	terraLib.openPort(resource.ingress, 2383)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_security_group doesn't openSQL Analysis Services Port 2383",
		"keyActualValue": "aws_security_group opens SQL Analysis Services Port 2383",
	}
}
