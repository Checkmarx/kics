package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::Lambda::Permission"
	properties := resource.Properties
	contains(properties.Principal, "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Principal", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.Principal is not wildcard", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.Principal is wildcard", [name]),
	}
}
