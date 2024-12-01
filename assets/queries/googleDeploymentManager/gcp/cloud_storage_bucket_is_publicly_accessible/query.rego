package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	public_access_users := ["allUsers", "allAuthenticatedUsers"]
	resource.type == "storage.v1.bucketAccessControl"

	public_access_users[j] == resource.properties.entity

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.entity", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'entity' should not equal to 'allUsers' or 'allAuthenticatedUsers'",
		"keyActualValue": sprintf("'entity' is equal to '%s'", [resource.properties.entity]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "entity"], []),
	}
}
