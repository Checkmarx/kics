package Cx

import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_network_acl[name]

	terra_lib.openPort(resource.ingress[idx], 22)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_network_acl[%s].ingress", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_network_acl[%s].ingress[%d] 'SSH' (Port:22) is not public", [name, idx]),
		"keyActualValue": sprintf("aws_network_acl[%s].ingress[%d] 'SSH' (Port:22) is public", [name, idx]),
	}
}
