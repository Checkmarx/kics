package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:ssm:Parameter"
	resource.properties.type == "SecureString"
	not common_lib.valid_key(resource.properties, "key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties.type", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'resources.%s.properties.key_id' should be defined", [name]),
		"keyActualValue": sprintf("'resources.%s.properties.key_id' is not defined", [name]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "type"], []),
	}
}
