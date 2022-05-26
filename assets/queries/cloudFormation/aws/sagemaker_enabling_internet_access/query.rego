package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::SageMaker::NotebookInstance"
	properties := resource.Properties
	properties.DirectInternetAccess != "Disabled"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DirectInternetAccess", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DirectInternetAccess is enabled", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DirectInternetAccess is disabled", [name]),
	}
}
