package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	startswith(resource.apiVersion, "cache.azure.crossplane.io")
	resource.kind == "Redis"
	forProvider := resource.spec.forProvider

	forProvider.enableNonSslPort == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.forProvider.enableNonSslPort", [resource.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "enableNonSslPort should be set to false or undefined",
		"keyActualValue": "enableNonSslPort is set to true",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], ["enableNonSslPort"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	startswith(resourceList[j].base.apiVersion, "cache.azure.crossplane.io")
	resourceList[j].base.kind == "Redis"
	forProvider := resourceList[j].base.spec.forProvider
	forProvider.enableNonSslPort == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.enableNonSslPort", [resourceList[j].base.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "enableNonSslPort should be set to false or undefined",
		"keyActualValue": "enableNonSslPort is set to true",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], ["enableNonSslPort"]),
	}
}
