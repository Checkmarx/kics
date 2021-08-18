package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"

	not common_lib.valid_key(resource.Properties, "StorageEncrypted")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::RDS::DBInstance"

	properties := resource.Properties

	properties.StorageEncrypted == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StorageEncrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted is set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StorageEncrypted is set to false", [name]),
	}
}
