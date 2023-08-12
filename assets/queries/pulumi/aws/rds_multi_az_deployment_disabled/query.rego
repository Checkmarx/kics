package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:rds:Instance"
	resource.properties.multiAz == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties.multiAz", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'resources.%s.properties.multiAz' should be set to 'true'", [name]),
		"keyActualValue": sprintf("'resources.%s.properties.multiAz' is set to 'false'", [name]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "multiAz"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:rds:Instance"
	not common_lib.valid_key(resource.properties, "multiAz")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'resources.%s.properties.multiAz' should be defined and set to 'true'", [name]),
		"keyActualValue": sprintf("'resources.%s.properties.multiAz' is not defined", [name]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}