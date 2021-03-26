package Cx


CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	object.get(resource.Properties, "IsLogging", "undefined") == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.IsLogging", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsLogging' is true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsLogging' is false", [name]),
	}
}
