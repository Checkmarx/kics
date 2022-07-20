package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Redis"
	forProvider := resource.spec.forProvider

	forProvider.enableNonSslPort == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": "spec.forProvider.enableNonSslPort",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "enableNonSslPort should be set to false",
		"keyActualValue": "enableNonSslPort is set to true",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], ["enableNonSslPort"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	resourceList[j].base.kind == "Redis"
	forProvider := resourceList[j].base.spec.forProvider
	forProvider.enableNonSslPort == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider.enableNonSslPort", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "enableNonSslPort should be set to false",
		"keyActualValue": "enableNonSslPort is set to true",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], ["enableNonSslPort"]),
	}
}
