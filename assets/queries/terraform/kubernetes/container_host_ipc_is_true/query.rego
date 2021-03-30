package Cx

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec

	spec.host_ipc == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.host_ipc", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_ipc' is undefined or false",
		"keyActualValue": "Attribute 'host_ipc' is true",
	}
}
