package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::User"
	pass := resource.Properties.LoginProfile.Password
	checkPass(pass)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LoginProfile.Password", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LoginProfile.Password' should be a ref to a secretsmanager value", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LoginProfile.Password' is a string literal", [name]),
	}
}

checkPass(pass) {
	is_string(pass)
    not contains(pass, "secretsmanager")
}
