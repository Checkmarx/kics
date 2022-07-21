package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "compute.azure.crossplane.io")
	resource.kind == "AKSCluster"
	spec := resource.spec

	spec.disableRBAC == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": "spec.disableRBAC",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "disableRBAC should be set to false",
		"keyActualValue": "disableRBAC is set to true",
		"searchLine": common_lib.build_search_line(["spec", "disableRBAC"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "compute.azure.crossplane.io")
	resourceList[j].base.kind == "AKSCluster"
	spec := resourceList[j].base.spec
	spec.disableRBAC == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.disableRBAC", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "disableRBAC should be set to false",
		"keyActualValue": "disableRBAC is set to true",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "disableRBAC"], []),
	}
}
