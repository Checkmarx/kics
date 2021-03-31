package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::CloudTrail::Trail"
	object.get(resource.Properties, "KMSKeyId", "not found") == "not found"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.KMSKeyId' should exist", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.KMSKeyId' doesn't exist", [name]),
	}
}
