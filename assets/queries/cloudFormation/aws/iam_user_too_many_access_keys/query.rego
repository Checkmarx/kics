package Cx

import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::AccessKey"
	user := resource.Properties.UserName
	findAnotherAccessKey(name, user)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
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
