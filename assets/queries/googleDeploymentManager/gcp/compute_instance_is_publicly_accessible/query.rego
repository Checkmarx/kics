package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "compute.v1.instance"

	resource.properties.networkInterfaces[idx].accessConfigs

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.networkInterfaces", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'accessConfigs' should be undefined",
		"keyActualValue": "'accessConfigs' is defined and not null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "networkInterfaces", idx, "accessConfigs"], []),
	}
}
