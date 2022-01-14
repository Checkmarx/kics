package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Group"

	count({x | user := input.document[_].Resources[x]; user.Type == "AWS::IAM::User"; has_group(user.Properties.Groups, name)}) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s has at least one user", [name]),
		"keyActualValue": sprintf("Resources.%s does not have at least one user", [name]),
	}
}

has_group(groups, name) {
	groups[x] == name
}
