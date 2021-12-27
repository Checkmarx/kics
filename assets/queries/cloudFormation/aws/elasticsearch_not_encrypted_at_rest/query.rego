package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	properties := resource.Properties

	not common_lib.valid_key(properties, "EncryptionAtRestOptions")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions is undefined or null", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	properties := resource.Properties

	properties.EncryptionAtRestOptions.Enabled != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EncryptionAtRestOptions.Enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions is enabled", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions is disabled", [name]),
	}
}
