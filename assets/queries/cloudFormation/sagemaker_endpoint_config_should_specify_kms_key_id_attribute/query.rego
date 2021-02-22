package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::SageMaker::EndpointConfig"
	properties := resource.Properties
	object.get(properties, "KmsKeyId", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KmsKeyId is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.KmsKeyId is undefined", [name]),
	}
}
