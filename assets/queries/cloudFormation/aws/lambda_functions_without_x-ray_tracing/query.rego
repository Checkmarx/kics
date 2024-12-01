package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource = document.Resources[name]
	resource.Type == "AWS::Lambda::Function"
	properties := resource.Properties
	properties.TracingConfig.Mode == "PassThrough"

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.TracingConfig.Mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "TracingConfig.Mode should be set to 'Active'",
		"keyActualValue": "TracingConfig.Mode is set to 'PassThrough'",
	}
}

CxPolicy[result] {
	some document in input.document
	resource = document.Resources[name]
	resource.Type == "AWS::Lambda::Function"
	properties := resource.Properties
	not common_lib.valid_key(properties, "TracingConfig")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Property 'TracingConfig' should be defined",
		"keyActualValue": "Property 'TracingConfig' is undefined",
	}
}
