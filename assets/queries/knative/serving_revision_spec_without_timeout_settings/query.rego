package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "serving.knative.dev")
	resource.kind == "Service"
	metadata := resource.metadata
	spec := resource.spec.ConfigurationSpec.template.spec

	not common_lib.valid_key(spec, "timeoutSeconds")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("spec.ConfigurationSpec.template.spec", []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Service should have 'timeoutSeconds' defined in 'ConfigurationSpec.template.spec'",
		"keyActualValue": "Service 'timeoutSeconds' is not defined in 'ConfigurationSpec.template.spec'",
		"searchLine": common_lib.build_search_line(["spec", "ConfigurationSpec", "template", "spec"], []),
	}
}
