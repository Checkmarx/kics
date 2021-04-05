package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Kinesis::Stream"

	object.get(resource.Properties, "StreamEncryption", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Kinesis::Stream"

	object.get(resource.Properties.StreamEncryption, "EncryptionType", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StreamEncryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption.EncryptionType is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption.EncryptionType is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Kinesis::Stream"

	object.get(resource.Properties.StreamEncryption, "KeyId", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.StreamEncryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StreamEncryption.KeyId is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StreamEncryption.KeyId is undefined", [name]),
	}
}
