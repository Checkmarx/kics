package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	resource.properties.networkInterfaces[idx].accessConfigs

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'privateClusterConfig' is defined and not null",
		"keyActualValue": "'privateClusterConfig' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "networkInterfaces", idx, "accessConfigs"], []),
	}
}
