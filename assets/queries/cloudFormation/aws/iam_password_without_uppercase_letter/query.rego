package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	password := resource.Properties.LoginProfile.Password
	is_string(password)
    not contains(lower(password), "secretsmanager")
	not regex.match(".*[A-Z]", password)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile.Password", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.LoginProfile.Password' contains uppercase letter",
		"keyActualValue": "'Resources.Properties.LoginProfile.Password' doesnt contains uppercase letter",
	}
}
