package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::Bucket"
	prop := resource.Properties
	object.get(prop, "LoggingConfiguration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties' has property 'LoggingConfiguration'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties' doesn't have property 'LoggingConfiguration'", [name]),
	}
}
