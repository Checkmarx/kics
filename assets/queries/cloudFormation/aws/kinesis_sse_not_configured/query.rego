package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Kinesis::Stream"

	not common_lib.valid_key(resource.Properties, "StreamEncryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Kinesis::Stream"

	not common_lib.valid_key(resource.Properties.StreamEncryption, "EncryptionType")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.StreamEncryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption.EncryptionType is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption.EncryptionType is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Kinesis::Stream"

	not common_lib.valid_key(resource.Properties.StreamEncryption, "KeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.StreamEncryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption.KeyId is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption.KeyId is undefined", [name]),
	}
}
