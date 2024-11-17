package Cx

import data.generic.cloudformation as cf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.Resources[name]
	password := resource.Properties.LoginProfile.Password
	is_string(password)
	not contains(lower(password), "secretsmanager")
	count(password) < 14

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile.Password", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.LoginProfile.Password' has a minimum length of 14",
		"keyActualValue": "'Resources.Properties.LoginProfile.Password' doesn't have a minimum length of 14",
	}
}
