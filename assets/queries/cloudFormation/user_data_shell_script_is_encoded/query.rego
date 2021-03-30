package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::EC2::LaunchTemplate"
	userData := resource.Properties.LaunchTemplateData.UserData

	decodedResult := check_user_data(userData)
	startswith(decodedResult, "#!/")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LaunchTemplateData.UserData", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.LaunchTemplateData.UserData' is not shell script", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.LaunchTemplateData.UserData' is shell script", [name]),
	}
}

check_user_data(user_data) = result {
	user_data == null
	result := base64.decode("dGVzdA==") #test
}

check_user_data(user_data) = result {
	user_data != null
	result := base64.decode(user_data)
}
