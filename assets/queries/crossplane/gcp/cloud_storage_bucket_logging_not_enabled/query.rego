package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "storage.gcp.crossplane.io")
	resource.kind == "Bucket"
	spec := resource.spec

	not common_lib.valid_key(spec, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Bucket logging should be defined",
		"keyActualValue": "Bucket logging is not defined",
		"searchLine": common_lib.build_search_line(["spec"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "storage.gcp.crossplane.io")
	resourceList[j].base.kind == "Bucket"
	spec := resourceList[j].base.spec
	not common_lib.valid_key(spec, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Bucket logging should be defined",
		"keyActualValue": "Bucket logging is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec"], []),
	}
}
