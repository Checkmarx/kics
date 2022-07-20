package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Queue"
	forProvider := resource.spec.forProvider

	not common_lib.valid_key(forProvider, "kmsMasterKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": resource.metadata.name,
		"searchKey": "spec.forProvider",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "kmsMasterKeyId should be defined",
		"keyActualValue": "kmsMasterKeyId is not defined",
		"searchLine": common_lib.build_search_line(["spec", "forProvider"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "Composition"
	resourceList := resource.spec.resources

	resourceList[j].base.kind == "Queue"
	forProvider := resourceList[j].base.spec.forProvider
	not common_lib.valid_key(forProvider, "kmsMasterKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceList[j].base.kind,
		"resourceName": resourceList[j].base.metadata.name,
		"searchKey": sprintf("spec.resources.base.metadata.name={{%s}}}.spec.forProvider", [resourceList[j].base.metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "kmsMasterKeyId should be defined",
		"keyActualValue": "kmsMasterKeyId is not defined",
		"searchLine": common_lib.build_search_line(["spec", "resources", j, "base", "spec", "forProvider"], []),
	}
}
