package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

decode_and_check_private_key(user_base64_data) {
	decoded_user_data := base64.decode(user_base64_data)
	regex.match(`-----BEGIN ((EC|PGP|DSA|RSA|OPENSSH) )?PRIVATE KEY( BLOCK)?-----`, decoded_user_data)
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	user_data := resource.user_data_base64
	not user_data == null
	decode_and_check_private_key(user_data)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_launch_configuration",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_launch_configuration[%s].user_data_base64", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].user_data_base64 shouldn't contain RSA Private Key", [name]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].user_data_base64 contains RSA Private Key", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_launch_configuration", name, "user_data_base64"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_launch_configuration", "user_data_base64")
	user_data := module.user_data_base64
	not user_data == null
	decode_and_check_private_key(user_data)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].user_data_base64", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'user_data_base64' shouldn't contain RSA Private Key",
		"keyActualValue": "'user_data_base64' contains RSA Private Key",
		"searchLine": common_lib.build_search_line(["module", name, "user_data_base64"], []),
	}
}
