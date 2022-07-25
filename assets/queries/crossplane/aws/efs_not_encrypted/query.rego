package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "efs.aws.crossplane.io")
	resource.kind == "FileSystem"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider", [resource.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "encrypted should be defined and set to true",
		"keyActualValue": "encrypted is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "efs.aws.crossplane.io")
	resource.kind == "FileSystem"
	forProvider := resource.spec.forProvider

	forProvider.encrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.encrypted", [resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "encrypted should be set to true",
		"keyActualValue": "encrypted is set to false",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], ["encrypted"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "efs.aws.crossplane.io")
	resourceList[j].base.kind == "FileSystem"
	forProvider := resourceList[j].base.spec.forProvider
	not common_lib.valid_key(forProvider, "encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "encrypted should be defined and set to true",
		"keyActualValue": "encrypted is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "efs.aws.crossplane.io")
	resourceList[j].base.kind == "FileSystem"
	forProvider := resourceList[j].base.spec.forProvider
	forProvider.encrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.encrypted", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "encrypted should be set to true",
		"keyActualValue": "encrypted is set to false",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], ["encrypted"]),
	}
}
