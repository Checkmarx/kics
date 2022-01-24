package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::Serverless::Function"
	properties := resource.Properties
	properties.Tracing != "Active"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.Tracing", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Tracing' is set to 'Active'",
		"keyActualValue": sprintf("'Tracing' is set to '%s'", [properties.Tracing]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "Tracing"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::Serverless::Function"
	properties := resource.Properties
	not common_lib.valid_key(properties, "Tracing")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Property 'TracingConfig' is defined and not null",
		"keyActualValue": "Property 'TracingConfig' is undefined or null",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
