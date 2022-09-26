package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_launch_configuration", "user_data_base64")
	common_lib.valid_key(module, "user_data_base64")
	decoded_result := base64.decode(module.user_data_base64)
	startswith(decoded_result, "#!/")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'user_data_base64' should be undefined or not script",
		"keyActualValue": "'user_data_base64' is defined",
		"searchLine": common_lib.build_search_line(["module", name, "user_data_base64"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	common_lib.valid_key(resource, "user_data_base64")
	decoded_result := base64.decode(resource.user_data_base64)
	startswith(decoded_result, "#!/")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_launch_configuration",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_launch_configuration[%s].user_data_base64", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].user_data_base64 should be undefined or not script", [name]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].user_data_base64 is defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_launch_configuration", name, "user_data_base64"], []),
	}
}
