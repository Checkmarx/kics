package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	resource.Type == "AWS::CodeStar::GitHubRepository"

	object.get(resource.Properties, "IsPrivate", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.IsPrivate' is set", [name]),
		"keyActualValue": sprintf("'Resources.%s.IsPrivate' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]

	resource.Type == "AWS::CodeStar::GitHubRepository"

	resource.Properties.IsPrivate != true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.IsPrivate", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.IsPrivate' is set to true", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.IsPrivate' is not set to true", [name]),
	}
}
