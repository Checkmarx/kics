package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	password := resource.Properties.LoginProfile.Password
	is_string(password)
	not regex.match(".*[-+_!@#$%^&*.,?]", password)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile.Password", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Resources.Properties.LoginProfile.Password' contains symbol",
		"keyActualValue": "'Resources.Properties.LoginProfile.Password' doesnt contain symbol",
	}
}
