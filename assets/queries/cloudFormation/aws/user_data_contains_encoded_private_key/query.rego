package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::AutoScaling::LaunchConfiguration"
	prop := resource.Properties
	userData := prop.UserData

    contains(userData,"LS0tLS1CR")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.UserData", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.UserData' shouldn't contain RSA Private Key", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.UserData' contains RSA Private Key", [name]),
	}
}
