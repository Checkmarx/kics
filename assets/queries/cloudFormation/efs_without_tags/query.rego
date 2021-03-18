package Cx

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::EFS::FileSystem"
	properties := resource.Properties
	object.get(properties, "FileSystemTags", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.FileSystemTags' is defined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.FileSystemTags' is undefined", [name]),
	}
}
