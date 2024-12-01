package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	properties := resource.Properties

	not common_lib.valid_key(properties, "EncryptionAtRestOptions")

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions is undefined or null", [name]),
	}
}

CxPolicy[result] {
	some docs in input.document
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	properties := resource.Properties

	common_lib.valid_key(properties, "EncryptionAtRestOptions")

	not common_lib.valid_key(properties.EncryptionAtRestOptions, "KmsKeyId")

	result := {
		"documentId": docs.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.EncryptionAtRestOptions", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions.KmsKeyId should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions.KmsKeyId is undefined", [name]),
	}
}
