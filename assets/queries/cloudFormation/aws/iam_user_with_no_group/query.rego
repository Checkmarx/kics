package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::IAM::User"
	properties := resource.Properties

	not common_lib.valid_key(properties, "Groups")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'Resources.Properties should contain Groups",
		"keyActualValue": "'Resources.Properties' does not contain Groups",
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::IAM::User"
	groups := resource.Properties.Groups
	count(groups) == 0

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Groups", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.Groups' should contain groups",
		"keyActualValue": "'Resources.Properties.Groups' is empty",
	}
}
