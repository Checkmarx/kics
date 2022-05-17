package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::ManagedPolicy"
	count(resource.Properties.Users) > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": name,
		"searchKey": sprintf("Resources.%s.Properties.Users", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s is assigned to a set of users", [name]),
		"keyActualValue": sprintf("Resources.%s should be assigned to a set of groups", [name]),
	}
}
