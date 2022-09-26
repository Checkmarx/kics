package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resources := input.document[i].Resources
	resource := resources[k]

	resource.Type == "AWS::Lambda::Function"

	some j
	resources[j].Type == "AWS::Lambda::Function"
	resources[j].Properties.Role == resource.Properties.Role
	k != j

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, k),
		"searchKey": sprintf("Resources.%s.Properties.Role", [k]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Each AWS Lambda Function has a unique role",
		"keyActualValue": sprintf("Resource.%s.Properties.Role is assigned to another funtion", [k]),
	}
}
