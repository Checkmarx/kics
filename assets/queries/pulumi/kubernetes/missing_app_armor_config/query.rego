package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "kubernetes:core/v1:Pod"

	metadata := resource.properties.metadata
	annotations := metadata.annotations	
	annotations != null
	not hasExpectedKey(annotations)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.metadata.annotations", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Pod should have annotation 'container.apparmor.security.beta.kubernetes.io' defined",
		"keyActualValue": "Pod does not have annotation 'container.apparmor.security.beta.kubernetes.io' defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["metadata", "annotations"]),
	}
}

hasExpectedKey(annotations){
	annotations[key]
	expectedKey := "container.apparmor.security.beta.kubernetes.io"
	startswith(key, expectedKey)
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "kubernetes:core/v1:Pod"

	metadata := resource.properties.metadata
	not common_lib.valid_key(metadata , "annotations")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.metadata", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Pod should have annotation 'container.apparmor.security.beta.kubernetes.io' defined",
		"keyActualValue": "Pod does not have annotations defined in metadata",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["metadata"]),
	}
}
