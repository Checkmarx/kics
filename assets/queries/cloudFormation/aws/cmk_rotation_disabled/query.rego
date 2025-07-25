package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::KMS::Key"
	cf_lib.isCloudFormationTrue(resource.Properties.Enabled) 
	not common_lib.valid_key(resource.Properties, "PendingWindowInDays")
	not common_lib.valid_key(resource.Properties, "EnableKeyRotation")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' should be defined and not null", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::KMS::Key"
	cf_lib.isCloudFormationTrue(resource.Properties.Enabled)
	not common_lib.valid_key(resource.Properties, "PendingWindowInDays")
	cf_lib.isCloudFormationFalse(resource.Properties.EnableKeyRotation)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.EnableKeyRotation", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' should be true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' is false", [name]),
	}
}
