package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := terraLib.getSpecInfo(resource[name])

	specInfo.spec.host_ipc == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].%s.host_ipc", [resourceType, name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_ipc' is undefined or false",
		"keyActualValue": "Attribute 'host_ipc' is true",
	}
}
