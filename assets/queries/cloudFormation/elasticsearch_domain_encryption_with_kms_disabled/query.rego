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

	common_lib.valid_key(properties, "EncryptionAtRestOptions")

    not common_lib.valid_key(properties.EncryptionAtRestOptions,"KmsKeyId")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.EncryptionAtRestOptions", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions.KmsKeyId is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions.KmsKeyId is undefined", [name]),
	}
}
