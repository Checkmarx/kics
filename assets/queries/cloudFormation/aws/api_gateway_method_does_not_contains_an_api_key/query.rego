package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::ApiGateway::Method"

	not common_lib.valid_key(resource.Properties, "ApiKeyRequired")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ApiKeyRequired should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ApiKeyRequired is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::ApiGateway::Method"

	cf_lib.isCloudFormationFalse(resource.Properties.ApiKeyRequired)

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.ApiKeyRequired", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.ApiKeyRequired should be true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.ApiKeyRequired is false", [name]),
	}
}
