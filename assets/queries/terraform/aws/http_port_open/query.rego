package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	terraLib.openPort(resource.ingress, 80)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_security_group.ingress doesn't open the HTTP port (80)",
		"keyActualValue": "aws_security_group.ingress opens the HTTP port (80)",
	}
}
