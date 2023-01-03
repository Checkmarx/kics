package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Properties.PolicyName == "AWSSupportAccess"
	resource.Type == "AWS::IAM::Policy"

	not hasAttributeList(resource.Properties, "Roles")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Roles' should be set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Roles' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Properties.PolicyName == "AWSSupportAccess"
	resource.Type == "AWS::IAM::Policy"

	not hasAttributeList(resource.Properties, "Users")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Users' should be set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Users' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Properties.PolicyName == "AWSSupportAccess"
	resource.Type == "AWS::IAM::Policy"

	not hasAttributeList(resource.Properties, "Groups")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Groups' should be set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Groups' is undefined", [name]),
	}
}

hasAttributeList(resource, attribute) {
	count(resource[attribute]) > 0
} else = false {
	true
}
