package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Method"

	none := "NONE"
	resource.Properties.AuthorizationType == none

	options := "OPTIONS"
	resource.Properties.HttpMethod != options

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AuthorizationType is %s and Resources.%s.Properties.HttpMethod should be %s", [name, none, name, options]),
		"keyActualValue": sprintf("Resources.%s.Properties.AuthorizationType is %s and Resources.%s.Properties.HttpMethod is not %s", [name, none, name, options]),
	}
}
