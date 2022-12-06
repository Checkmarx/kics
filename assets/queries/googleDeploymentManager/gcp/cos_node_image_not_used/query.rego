package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.nodePool"

	not startswith(lower(resource.properties.config.imageType), "cos")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.config.imageType", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'config.imageType' should start with 'cos'",
		"keyActualValue": sprintf("'config.imageType' is %s", [resource.properties.config.imageType]), 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "config", "imageType"], []),
	}
}
