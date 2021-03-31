package Cx

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec

	spec.host_pid == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.host_pid", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_pid' is undefined or false",
		"keyActualValue": "Attribute 'host_pid' is true",
	}
}
