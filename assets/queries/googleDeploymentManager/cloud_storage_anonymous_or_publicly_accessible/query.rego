package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "storage.v1.bucket"

	not common_lib.valid_key(resource.properties, "acl")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'acl' should be defined",
		"keyActualValue": "'acl' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "storage.v1.bucket"
	public_access_users := ["allUsers", "allAuthenticatedUsers"]

	resource.properties.acl[j].entity == public_access_users[k]

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.acl[%d].entity", [resource.name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("properties.acl[%d].entity should not equal to 'allUsers' or 'AllAuthenticatedUsers'", [j]),
		"keyActualValue": sprintf("properties.acl[%d].entity is equal to 'allUsers' or 'AllAuthenticatedUsers'", [j]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "acl", j, "entity"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "storage.v1.bucket"

	not common_lib.valid_key(resource.properties, "defaultObjectAcl")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'defaultObjectAcl' should be defined",
		"keyActualValue": "'defaultObjectAcl' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "storage.v1.bucket"
	public_access_users := ["allUsers", "allAuthenticatedUsers"]

	resource.properties.defaultObjectAcl[j].entity == public_access_users[k]

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.defaultObjectAcl[%d].entity", [resource.name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("properties.defaultObjectAcl[%d].entity should not equal to 'allUsers' or 'AllAuthenticatedUsers'", [j]),
		"keyActualValue": sprintf("properties.defaultObjectAcl[%d].entity is equal to 'allUsers' or 'AllAuthenticatedUsers'", [j]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "defaultObjectAcl", j, "entity"], []),
	}
}

