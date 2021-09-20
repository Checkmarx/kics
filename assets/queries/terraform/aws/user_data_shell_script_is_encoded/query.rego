package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_launch_configuration", "user_data_base64")
	decode_result := check_data_base64(module.user_data_base64)
	startswith(decode_result, "#!/")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'user_data_base64' is undefined",
		"keyActualValue": "'user_data_base64' is defined",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

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
		"searchLine": common_lib.build_search_line(["resource", "aws_launch_configuration", name], []),
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
