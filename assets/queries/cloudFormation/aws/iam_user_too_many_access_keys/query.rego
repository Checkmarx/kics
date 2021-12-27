package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::AccessKey"
	user := resource.Properties.UserName
	findAnotherAccessKey(name, user)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s' is the only AccessKey of user '%s'", [name, user]),
		"keyActualValue": sprintf("'Resources.%s' is not the only AccessKey of user '%s'", [name, user]),
	}
}

findAnotherAccessKey(firstKey, userName) {
	key := input.document[_].Resources[secondKey]
	firstKey != secondKey
	key.Properties.UserName == userName
} else = false {
	true
}
