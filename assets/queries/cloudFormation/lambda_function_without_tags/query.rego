package Cx

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::Lambda::Function"
	properties := resource.Properties
	object.get(properties, "Tags", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Tags' is defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Tags' is undefined", [name]),
	}
}
