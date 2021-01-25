package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Project.Type == "AWS::CodeBuild::Project"
	properties := resource.Project.Properties
	object.get(properties, "EncryptionKey", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Project.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Project.Properties.EncryptionKey' is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Project.Properties.EncryptionKey' is undefined", [name]),
	}
}
