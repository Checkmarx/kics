package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "compute.v1.instance"

	resource.properties.metadata.items[j].key == "enable-oslogin"
	resource.properties.metadata.items[j].value == false

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.metadata.items[%d]", [resource.name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'metadata.items[%d]'.value should be true", [j]),
		"keyActualValue": sprintf("'metadata.items[%d]'.value is false", [j]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "metadata", "items", j, "value"], []),
	}
}
