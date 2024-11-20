package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "dns.v1.managedZone"

	not common_lib.valid_key(resource.properties, "dnssecConfig")

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'dnssecConfig' should be defined and not null",
		"keyActualValue": "'dnssecConfig' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "dns.v1.managedZone"

	not common_lib.valid_key(resource.properties.dnssecConfig, "state")

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.dnssecConfig", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'state' should be defined and not null",
		"keyActualValue": "'state' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "dnssecConfig"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "dns.v1.managedZone"

	resource.properties.dnssecConfig.state != "on"

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.dnssecConfig.state", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'state' should be set to 'on'",
		"keyActualValue": "'state' is not set to 'on'",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "dnssecConfig", "state"], []),
	}
}
