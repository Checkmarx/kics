package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECR::Repository"
	properties := resource.Properties

	not common_lib.valid_key(properties, "ImageScanningConfiguration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ImageScanningConfiguration should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ImageScanningConfiguration is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECR::Repository"
	properties := resource.Properties

	cf_lib.isCloudFormationFalse(properties.ImageScanningConfiguration.ScanOnPush)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ImageScanningConfiguration.ScanOnPush", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ImageScanningConfiguration.ScanOnPush should be set to true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ImageScanningConfiguration.ScanOnPush is set to false", [name]),
	}
}

