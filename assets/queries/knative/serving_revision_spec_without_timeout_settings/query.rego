package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "serving.knative.dev")
	resource.kind == "Service"
	metadata := resource.metadata
	spec := resource.spec.template.spec

	not common_lib.valid_key(spec, "timeoutSeconds")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Service should have 'timeoutSeconds' defined in 'template.spec'",
		"keyActualValue": "Service 'timeoutSeconds' is not defined in 'template.spec'",
		"searchLine": common_lib.build_search_line(["spec", "template", "spec"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "serving.knative.dev")
	resource.kind == "Service"
	metadata := resource.metadata
	timeoutSeconds := resource.spec.template.spec.timeoutSeconds

	timeoutSeconds == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.template.spec.timeoutSeconds", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Service should have 'timeoutSeconds' defined to a value higher than '0'",
		"keyActualValue": "Service 'timeoutSeconds' is set to '0'",
		"searchLine": common_lib.build_search_line(["spec", "template", "spec"], ["timeoutSeconds"]),
	}
}
