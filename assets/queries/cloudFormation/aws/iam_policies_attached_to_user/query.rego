package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	policies := resource.Properties.Policies
	policies != []

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Policies", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Policies' should be undefined or empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Policies' is not empty", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	policies := resource.Properties.ManagedPoliciesArns
	policies != []

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ManagedPoliciesArns", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.ManagedPoliciesArns' is undefined or empty", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.ManagedPoliciesArns' is not empty", [name]),
	}
}
