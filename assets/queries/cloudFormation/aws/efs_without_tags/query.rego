package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::EFS::FileSystem"
	properties := resource.Properties
	not common_lib.valid_key(properties, "FileSystemTags")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.FileSystemTags' is defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.FileSystemTags' is undefined or null", [name]),
	}
}
