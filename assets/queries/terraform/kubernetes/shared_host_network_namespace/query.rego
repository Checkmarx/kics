package Cx

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	resource[name].spec.host_network == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.host_network", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].spec.host_network is undefined or set to false", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].spec.host_network is set to true", [resourceType, name]),
	}
}
