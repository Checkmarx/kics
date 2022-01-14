package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	properties := resource.Properties

	not common_lib.valid_key(properties, "Groups")

    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'Resources.Properties should contain Groups",
		"keyActualValue": "'Resources.Properties' does not contain Groups",
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	groups := resource.Properties.Groups
	count(groups) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Groups", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.Groups' should contain groups",
		"keyActualValue": "'Resources.Properties.Groups' is empty",
	}
}
