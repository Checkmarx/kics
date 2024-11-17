package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::KMS::Key"
	resource.Properties.Enabled == false

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Enabled' should be true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Enabled' is false", [name]),
	}
}

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::KMS::Key"
	resource.Properties.PendingWindowInDays

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.PendingWindowInDays", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PendingWindowInDays' should be undefined", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PendingWindowInDays' is defined", [name]),
	}
}
