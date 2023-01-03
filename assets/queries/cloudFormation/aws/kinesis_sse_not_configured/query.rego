package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Kinesis::Stream"

	not common_lib.valid_key(resource.Properties, "StreamEncryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption is undefined", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Kinesis::Stream"

	not common_lib.valid_key(resource.Properties.StreamEncryption, "EncryptionType")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.StreamEncryption", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption.EncryptionType should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption.EncryptionType is undefined", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "StreamEncryption"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Kinesis::Stream"

	not common_lib.valid_key(resource.Properties.StreamEncryption, "KeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.StreamEncryption", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption.KeyId should be set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption.KeyId is undefined", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "StreamEncryption"]),
	}
}
