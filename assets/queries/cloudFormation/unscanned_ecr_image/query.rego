package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECR::Repository"
	properties := resource.Properties

	object.get(properties, "ImageScanningConfiguration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ImageScanningConfiguration is defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ImageScanningConfiguration is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECR::Repository"
	properties := resource.Properties

	isResFalse(properties.ImageScanningConfiguration.ScanOnPush)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.ImageScanningConfiguration.ScanOnPush", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ImageScanningConfiguration.ScanOnPush is set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ImageScanningConfiguration.ScanOnPush is set to false", [name]),
	}
}

isResFalse(answer) {
	answer == "false"
} else {
	answer == false
}
