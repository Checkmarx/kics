package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource = document.Resources[name]
	resource.Type == "AWS::Serverless::Function"
	properties := resource.Properties
	properties.Tracing != "Active"

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.Tracing", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Tracing' should be set to 'Active'",
		"keyActualValue": sprintf("'Tracing' is set to '%s'", [properties.Tracing]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Tracing"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource = document.Resources[name]
	resource.Type == "AWS::Serverless::Function"
	properties := resource.Properties
	not common_lib.valid_key(properties, "Tracing")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Property 'TracingConfig' should be defined and not null",
		"keyActualValue": "Property 'TracingConfig' is undefined or null",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
