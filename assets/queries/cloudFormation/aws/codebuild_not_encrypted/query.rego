package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Project.Type == "AWS::CodeBuild::Project"
	properties := resource.Project.Properties
	not common_lib.valid_key(properties, "EncryptionKey")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Project.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Project.Properties.EncryptionKey' is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Project.Properties.EncryptionKey' is undefined or null", [name]),
	}
}
