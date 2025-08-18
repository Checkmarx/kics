package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::KMS::Key"
	cf_lib.isCloudFormationFalse(resource.Properties.Enabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Enabled' should be true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Enabled' is false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::KMS::Key"
	resource.Properties.PendingWindowInDays

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PendingWindowInDays", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PendingWindowInDays' should be undefined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PendingWindowInDays' is defined", [name]),
	}
}
