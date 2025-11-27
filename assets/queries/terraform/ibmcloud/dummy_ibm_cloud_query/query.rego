package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.github_repository[example]
	not common_lib.valid_key(resource, "private")
	not common_lib.valid_key(resource, "visibility")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "github_repository",
		"resourceName": tf_lib.get_resource_name(resource, example),
		"searchKey": sprintf("github_repository[%s]", [example]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'private' or Attribute 'visibility' should be defined and not null",
		"keyActualValue": "Attribute 'private' and Attribute 'visibility' are undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.github_repository[example]
	resource.private == false
	not resource.visibility

	result := {
		"documentId": input.document[i].id,
		"resourceType": "github_repository",
		"resourceName": tf_lib.get_resource_name(resource, example),
		"searchKey": sprintf("github_repository[%s].private", [example]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'private' should be true",
		"keyActualValue": "Attribute 'private' is false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.github_repository[example]
	resource.visibility == "public"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "github_repository",
		"resourceName": tf_lib.get_resource_name(resource, example),
		"searchKey": sprintf("github_repository[%s].visibility", [example]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'visibility' should be 'private'",
		"keyActualValue": "Attribute 'visibility' is 'public'",
	}
}
