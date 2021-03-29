package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]

	terraLib.openPort(resource.ingress, 3389)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_security_group[%s].ingress doesn't open the remote desktop port (3389)", [name]),
		"keyActualValue": sprintf("aws_security_group[%s].ingress opens the remote desktop port (3389)", [name]),
	}
}
