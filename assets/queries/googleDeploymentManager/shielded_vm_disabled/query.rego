package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	not common_lib.valid_key(resource.properties, "shieldedInstanceConfig")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'shieldedInstanceConfig' should be defined and not null",
		"keyActualValue": "'shieldedInstanceConfig' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

fields := {"enableSecureBoot", "enableVtpm", "enableIntegrityMonitoring"}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	field := fields[_]
	not common_lib.valid_key(resource.properties.shieldedInstanceConfig, field)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.shieldedInstanceConfig", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' should be defined and not null", [field]),
		"keyActualValue": sprintf("'%s' is undefined or null", [field]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "shieldedInstanceConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	field := fields[_]
	resource.properties.shieldedInstanceConfig[field] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.shieldedInstanceConfig.%s", [resource.name, field]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should be set to true", [field]),
		"keyActualValue": sprintf("'%s' is set to false", [field]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "shieldedInstanceConfig", field], []),
	}
}
