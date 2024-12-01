package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource = doc.Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"
	properties := resource.Properties
	isResFalse(properties.TracingEnabled)

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.TracingEnabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.TracingEnabled should be true", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.TracingEnabled is false", [name]),
	}
}

CxPolicy[result] {
	some doc in input.document
	resource = doc.Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"
	properties := resource.Properties
	not common_lib.valid_key(properties, "TracingEnabled")

	result := {
		"documentId": doc.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.TracingEnabled should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.TracingEnabled is undefined", [name]),
	}
}

isResFalse("false") = true

isResFalse(false) = true
