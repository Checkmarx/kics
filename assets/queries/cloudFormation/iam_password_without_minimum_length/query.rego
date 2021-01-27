package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	password := resource.Properties.LoginProfile.Password
	count(password) < 14

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile.Password", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.LoginProfile.Password' has a minimum length of 14",
		"keyActualValue": "'Resources.Properties.LoginProfile.Password' doesn't have a minimum length of 14",
	}
}
