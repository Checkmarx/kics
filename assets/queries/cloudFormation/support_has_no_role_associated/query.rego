package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.PolicyName == "AWSSupportAccess"
	resource.Type == "AWS::IAM::Policy"

	not hasAttributeList(resource, "Roles")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Roles' is set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Roles' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.PolicyName == "AWSSupportAccess"
	resource.Type == "AWS::IAM::Policy"

	not hasAttributeList(resource, "Users")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Users' is set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Users' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.PolicyName == "AWSSupportAccess"
	resource.Type == "AWS::IAM::Policy"

	not hasAttributeList(resource, "Groups")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Groups' is set", [name]),
		"keyActualValue": sprintf("'Resources.%s.Groups' is undefined", [name]),
	}
}

hasAttributeList(resource, attribute) {
	object.get(resource, attribute, "undefined") != "undefined"
	count(resource[attribute]) > 0
} else = false {
	true
}
