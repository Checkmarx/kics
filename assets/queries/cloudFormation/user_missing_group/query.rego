package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	properties := resource.Properties
	object.get(properties, "Groups", "undefined") == "undefined"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "IncorrectValue",
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

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	groups := resource.Properties.Groups
	groups == null 
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.Groups", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.Groups' should contain groups",
		"keyActualValue": "'Resources.Properties.Groups' is null",
	}
}
