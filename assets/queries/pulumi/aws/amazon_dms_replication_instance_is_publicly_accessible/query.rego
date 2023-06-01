package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:dms:ReplicationInstance"

	resource.properties.publiclyAccessible == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.publiclyAccessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'publiclyAccessible' is should be set to 'false'",
		"keyActualValue": "Attribute 'publiclyAccessible' is defined to 'true'",
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "publiclyAccessible"], []),
	}
}


CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:dms:ReplicationInstance"

	not common_lib.valid_key(resource.properties, "publiclyAccessible")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'publiclyAccessible' should be defined",
		"keyActualValue": "Attribute 'publiclyAccessible' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}