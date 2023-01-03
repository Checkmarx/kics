package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::ECS::Service"
	role := resource.Properties.Role

	policy := getInlinePolicy(role)
	policy != "undefined"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Role", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.Role' should not refer an inline IAM Policy", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.Role' refers to inline IAM Policy '%s'", [name, policy]),
	}
}

getInlinePolicy(role) = policy {
	is_string(role)
	input.document[_].Resources[role].Type == "AWS::IAM::Policy"
	policy := role
} else = policy {
	is_object(role)
	input.document[_].Resources[role.Ref].Type == "AWS::IAM::Policy"
	policy := role.Ref
} else = "undefined" {
	true
}
