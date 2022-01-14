package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::Lambda::Function"
	properties := resource.Properties
	properties.TracingConfig.Mode == "PassThrough"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.TracingConfig.Mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "TracingConfig.Mode is set to 'Active'",
		"keyActualValue": "TracingConfig.Mode is set to 'PassThrough'",
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource = document.Resources[name]
	resource.Type == "AWS::Lambda::Function"
	properties := resource.Properties
	not common_lib.valid_key(properties, "TracingConfig")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Property 'TracingConfig' is defined",
		"keyActualValue": "Property 'TracingConfig' is undefined",
	}
}
