package Cx

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::SDB::Domain"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": name,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s is not defined", [name]),
		"keyActualValue": sprintf("Resources.%s is defined", [name]),
	}
}
