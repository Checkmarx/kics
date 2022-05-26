package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	password := resource.Properties.LoginProfile.Password
	is_string(password)
    not contains(lower(password), "secretsmanager")
	not regex.match(".*[a-z]", password)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile.Password", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.LoginProfile.Password' contains lowercase letter",
		"keyActualValue": "'Resources.Properties.LoginProfile.Password' doesn't contain lowercase letter",
	}
}
