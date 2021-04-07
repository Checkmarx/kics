package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SQS::Queue"

	object.get(resource.Properties, "KmsMasterKeyId", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KmsMasterKeyId is set", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.KmsMasterKeyId is undefined", [name]),
	}
}
