package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	pass := resource.Properties.LoginProfile.Password
	is_string(pass)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile.Password", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoginProfile.Password' should be a ref to a secretsmanager value", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoginProfile.Password' is a string literal", [name]),
	}
}
