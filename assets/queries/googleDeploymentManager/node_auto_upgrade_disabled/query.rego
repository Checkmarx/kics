package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "nodePools")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.nodePools", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'nodePools' to be defined and not null",
		"keyActualValue": "'nodePools' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "nodePools"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.nodePools, "upgradeSettings")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.nodePools.upgradeSettings", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'nodePools.upgradeSettings' to be defined and not null",
		"keyActualValue": "'nodePools.upgradeSettings' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "nodePools", "upgradeSettings"], []),
	}
}
