package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "compute.v1.instance"

	not common_lib.valid_key(resource.properties, "shieldedInstanceConfig")

	result := {
		"documentId": document.id,
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
	some document in input.document
	resource := document.resources[idx]
	resource.type == "compute.v1.instance"

	some field in fields
	not common_lib.valid_key(resource.properties.shieldedInstanceConfig, field)

	result := {
		"documentId": document.id,
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
	some document in input.document
	resource := document.resources[idx]
	resource.type == "compute.v1.instance"

	some field in fields
	resource.properties.shieldedInstanceConfig[field] == false

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.shieldedInstanceConfig.%s", [resource.name, field]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should be set to true", [field]),
		"keyActualValue": sprintf("'%s' is set to false", [field]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "shieldedInstanceConfig", field], []),
	}
}
