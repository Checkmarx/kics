package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::IAM::User"
	loginProfile := resource.Properties.LoginProfile
	loginProfile.Password
	loginProfile.PasswordResetRequired == false

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile.PasswordResetRequired", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoginProfile.PasswordResetRequired' should be configured as true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoginProfile.PasswordResetRequired' is configured as false", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::IAM::User"
	loginProfile := resource.Properties
	not common_lib.valid_key(loginProfile, "LoginProfile")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties' should be configured with LoginProfile with PasswordResetRequired property set to true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties' does not include LoginProfile", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::IAM::User"
	passwordResetRequired := resource.Properties.LoginProfile
	count(passwordResetRequired) == 1
	passwordResetRequired.Password

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoginProfile' should also include PasswordResetRequired property set to true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoginProfile' contains only Password property", [name]),
	}
}
