package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	decode_result := check_data_base64(resource.user_data_base64)
	startswith(decode_result, "#!/")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_launch_configuration[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].user_data_base64 is undefined", [name]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].user_data_base64 is defined", [name]),
	}
}

check_data_base64(data_base64) = result {
	data_base64 == null
	result := base64.decode("dGVzdA==") #test
}

check_data_base64(data_base64) = result {
	data_base64 != null
	result := base64.decode(data_base64)
}
