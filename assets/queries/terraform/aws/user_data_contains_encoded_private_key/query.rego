package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	user_data := resource.user_data_base64
	not user_data == null
	contains(user_data, "LS0tLS1CR")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_launch_configuration[%s].user_data_base64", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].user_data_base64 doesn't contain RSA Private Key", [name]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].user_data_base64 contains RSA Private Key", [name]),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_launch_configuration", "user_data_base64")
	user_data := module.user_data_base64
	not user_data == null
	contains(user_data, "LS0tLS1CR")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].user_data_base64", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'user_data_base64' doesn't contain RSA Private Key",
		"keyActualValue": "'user_data_base64' contains RSA Private Key",
		"searchLine": common_lib.build_search_line(["module", name, "user_data_base64"], []),
	}
}
