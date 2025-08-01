package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"
	properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.TracingEnabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.TracingEnabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.TracingEnabled should be true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.TracingEnabled is false", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"
	properties := resource.Properties
	not common_lib.valid_key(properties, "TracingEnabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.TracingEnabled should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.TracingEnabled is undefined", [name]),
	}
}
