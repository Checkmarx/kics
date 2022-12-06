package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "networkPolicy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'networkPolicy' should be defined and not null",
		"keyActualValue": "'networkPolicy' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.networkPolicy, "enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.networkPolicy", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'networkPolicy.enabled' should be defined and not null",
		"keyActualValue": "'networkPolicy.enabled' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "networkPolicy"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.networkPolicy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.networkPolicy.enabled", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'networkPolicy.enabled' should be true",
		"keyActualValue": "'networkPolicy.enabled' is false", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "networkPolicy", "enabled"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "addonsConfig")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'addonsConfig' should be defined and not null",
		"keyActualValue": "'addonsConfig' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.addonsConfig, "networkPolicyConfig")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.addonsConfig", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'addonsConfig.networkPolicyConfig' should be defined and not null",
		"keyActualValue": "'addonsConfig.networkPolicyConfig' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "addonsConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.addonsConfig.networkPolicyConfig, "disabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.addonsConfig.networkPolicyConfig", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'addonsConfig.networkPolicyConfig.disabled' should be defined and not null",
		"keyActualValue": "'addonsConfig.networkPolicyConfig.disabled' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "addonsConfig", "networkPolicyConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.addonsConfig.networkPolicyConfig.disabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.addonsConfig.networkPolicyConfig.disabled", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'addonsConfig.networkPolicyConfig.disabled' should be false",
		"keyActualValue": "'addonsConfig.networkPolicyConfig.disabled' is true", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "addonsConfig", "networkPolicyConfig", "disabled"], []),
	}
}
