package Cx

aws_cli_config_files = {"/etc/awscli.conf", "/etc/aws/config", "/etc/aws/credentials", "~/.aws/credentials", "~/.aws/config", "$HOME/.aws/credentials", "$HOME/.aws/config"}

check_aws_api_keys(mdata) {
	regex.find_n(`aws_access_key_id\s*=|AWS_ACCESS_KEY_ID\s*=|aws_secret_access_key\s*=|AWS_SECRET_ACCESS_KEY\s*=`, mdata, -1) > 0
}

check_aws_api_keys_or_config_files(remote) {
	check_aws_api_keys(remote.inline[_])
} else {
	contains(remote.inline[_], aws_cli_config_files[_])
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_instance[name]

	check_aws_api_keys(resource.user_data)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_instance[%s]", [name]),
		"issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("aws_instance[%s] should be using iam_instance_profile to assign a role with permissions", [name]),
        "keyActualValue": sprintf("aws_instance[%s].user_data is being used to configure AWS API keys", [name]),
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

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_instance[name]

	remote := resource.provisioner["remote-exec"]
	check_aws_api_keys_or_config_files(remote)

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_instance[%s].provisioner", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_instance[%s].provisioner.remote-exec is being used to configure AWS API keys", [name]),
		"keyActualValue": sprintf("aws_instance[%s] should be using iam_instance_profile to assign a role with permissions", [name]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_instance[name]

	file := resource.provisioner.file
	contains(file.destination, aws_cli_config_files[_])

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_instance[%s].provisioner", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_instance[%s].provisioner.file is being used to configure AWS API keys", [name]),
		"keyActualValue": sprintf("aws_instance[%s] should be using iam_instance_profile to assign a role with permissions", [name]),
	}
}
