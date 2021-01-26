package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	resource.Properties.MapPublicIpOnLaunch == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.MapPublicIpOnLaunch", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.MapPublicIpOnLaunch' is false",
		"keyActualValue": "'Resources.Properties.MapPublicIpOnLaunch' is true ",
	}
}
