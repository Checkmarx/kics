package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	resource.properties.networkInterfaces[idx].accessConfigs

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.networkInterfaces", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'accessConfigs' is undefined",
		"keyActualValue": "'accessConfigs' is defined and not null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "networkInterfaces", idx, "accessConfigs"], []),
	}
}
