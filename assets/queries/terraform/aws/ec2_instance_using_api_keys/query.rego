package Cx

import data.generic.common as common_lib

check_aws_api_keys(user_data) {
	regex.find_n(`aws_access_key_id\s*=|AWS_ACCESS_KEY_ID\s*=|aws_secret_access_key\s*=|AWS_SECRET_ACCESS_KEY\s*=`, user_data, -1) > 0
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_instance[name]

	check_aws_api_keys(resource.user_data)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance[%s].user_data is being used to configure AWS API keys", [name]),
		"keyActualValue": sprintf("aws_instance[%s] should be using iam_instance_profile to assign a role with permissions", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_instance[name]

	decoded := base64.decode(resource.user_data_base64)
	check_aws_api_keys(decoded)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance[%s].user_data is being used to configure AWS API keys", [name]),
		"keyActualValue": sprintf("aws_instance[%s] should be using iam_instance_profile to assign a role with permissions", [name]),
	}
}
