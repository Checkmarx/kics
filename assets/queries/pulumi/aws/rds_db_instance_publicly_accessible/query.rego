package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[name]
	resource.type == "aws:rds:Instance"
	resource.properties.publiclyAccessible == true

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties.publiclyAccessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'resources.%s.properties.publiclyAccessible' should be set to 'false'", [name]),
		"keyActualValue": sprintf("'resources.%s.properties.publiclyAccessible' is set to 'true'", [name]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "publiclyAccessible"], []),
	}
}
