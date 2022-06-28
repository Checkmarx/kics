package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Policy"
	users := resource.Properties.Policies[_].Users
	users != []
	users != null

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Policies.Users", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.Policies.Users should be replaced by Groups",
		"keyActualValue": "'Resources.Properties.Policies.Users' is not the correct definition.",
	}
}
