package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.github_repository[example]
	not common_lib.valid_key(resource, "private")
	not common_lib.valid_key(resource, "visibility")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("github_repository[%s]", [example]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'private' or Attribute 'visibility' are defined and not null",
		"keyActualValue": "Attribute 'private' and Attribute 'visibility' are undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.github_repository[example]
	resource.private == false
	not resource.visibility

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("github_repository[%s].private", [example]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'private' is true",
		"keyActualValue": "Attribute 'private' is false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.github_repository[example]
	resource.visibility == "public"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("github_repository[%s].visibility", [example]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'visibility' is 'private'",
		"keyActualValue": "Attribute 'visibility' is 'public'",
	}
}
