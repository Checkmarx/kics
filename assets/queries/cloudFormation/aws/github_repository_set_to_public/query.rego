package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	resource.Type == "AWS::CodeStar::GitHubRepository"

	not common_lib.valid_key(resource.Properties, "IsPrivate")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.IsPrivate' should be set", [name]),
		"keyActualValue": sprintf("'Resources.%s.IsPrivate' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	resource.Type == "AWS::CodeStar::GitHubRepository"

	not cf_lib.isCloudFormationTrue(resource.Properties.IsPrivate)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.IsPrivate", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsPrivate' should be set to true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsPrivate' is not set to true", [name]),
	}
}
