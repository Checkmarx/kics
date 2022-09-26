package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	resource.properties.canIpForward == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.canIpForward", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'canIpForward' should not be set to true",
		"keyActualValue": "'canIpForward' is set to true", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "canIpForward"], []),
	}
}
