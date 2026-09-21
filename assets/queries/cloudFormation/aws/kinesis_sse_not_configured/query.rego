package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

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
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption is undefined", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
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
		"searchValue": "EncryptionType",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption.EncryptionType should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption.EncryptionType is undefined", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], ["StreamEncryption"]),
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
		"searchValue": "KeyId",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption.KeyId should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption.KeyId is undefined", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], ["StreamEncryption"]),
	}
}
