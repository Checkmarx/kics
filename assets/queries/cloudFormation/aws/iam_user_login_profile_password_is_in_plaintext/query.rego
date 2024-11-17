package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	resource.Type == "AWS::IAM::User"
	pass := resource.Properties.LoginProfile.Password
	is_string(pass)

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile.Password", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoginProfile.Password' should be a ref to a secretsmanager value", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoginProfile.Password' is a string literal", [name]),
	}
}
