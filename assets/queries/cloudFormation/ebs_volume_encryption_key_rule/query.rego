package Cx

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::EC2::Volume"

	properties := resource.Properties

	object.get(properties, "KmsKeyId", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KmsKeyId should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.KmsKeyId is undefined", [key]),
	}
}
