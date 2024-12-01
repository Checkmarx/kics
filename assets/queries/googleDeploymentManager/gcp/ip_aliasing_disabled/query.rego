package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "ipAllocationPolicy")

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ipAllocationPolicy' should be defined and not null",
		"keyActualValue": "'ipAllocationPolicy' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.ipAllocationPolicy, "useIpAliases")

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.ipAllocationPolicy", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ipAllocationPolicy.useIpAliases' should be defined and not null",
		"keyActualValue": "'ipAllocationPolicy.useIpAliases' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "ipAllocationPolicy"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.ipAllocationPolicy.useIpAliases == false

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.ipAllocationPolicy.useIpAliases", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ipAllocationPolicy.useIpAliases' should be true",
		"keyActualValue": "'ipAllocationPolicy.useIpAliases' is false",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "ipAllocationPolicy", "useIpAliases"], []),
	}
}
