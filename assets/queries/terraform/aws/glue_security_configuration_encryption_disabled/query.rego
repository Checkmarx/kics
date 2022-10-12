package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_glue_security_configuration[name]

	configs := {
		"cloudwatch_encryption": "cloudwatch_encryption_mode",
		"job_bookmarks_encryption": "job_bookmarks_encryption_mode",
		"s3_encryption": "s3_encryption_mode",
	}

	encryptionConfig := resource.encryption_configuration

	configValue := configs[configKey]
	not common_lib.valid_key(encryptionConfig[configKey], configValue)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_glue_security_configuration",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_glue_security_configuration[%s].%s", [name, configKey]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_glue_security_configuration[%s].%s has '%s' defined and not null", [name, configKey, configValue]),
		"keyActualValue": sprintf("aws_glue_security_configKeyiguration[%s].%s has '%s' undefined or null", [name, configKey, configValue]),
		"searchLine": common_lib.build_search_line(["resource", "aws_glue_security_configuration", name, configKey], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_glue_security_configuration[name]

	configs := {
		"cloudwatch_encryption",
		"job_bookmarks_encryption",
	}

	config := configs[c]
	not common_lib.valid_key(resource.encryption_configuration[config], "kms_key_arn")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_glue_security_configuration",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_glue_security_configuration[%s].encryption_configuration.%s", [name, config]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_glue_security_configuration[%s].encryption_configuration.%s has 'kms_key_arn' defined and not null", [name, config]),
		"keyActualValue": sprintf("aws_glue_security_configuration[%s].encryption_configuration.%s has 'kms_key_arn' undefined or null", [name, config]),
		"searchLine": common_lib.build_search_line(["resource", "aws_glue_security_configuration", name, "encryption_configuration", config], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_glue_security_configuration[name]

	searchKeyInfo := wrong_config(resource.encryption_configuration)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_glue_security_configuration",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_glue_security_configuration[%s].%s", [name, searchKeyInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": searchKeyInfo.keyExpectedValue,
		"keyActualValue": searchKeyInfo.keyActualValue,
		"searchLine": common_lib.build_search_line(["resource", "aws_glue_security_configuration", name, searchKeyInfo.path], []),
	}
}

wrong_config(config) = searchKeyInfo {
	config.cloudwatch_encryption.cloudwatch_encryption_mode != "SSE-KMS"
	searchKeyInfo := {
		"path": "encryption_configuration.cloudwatch_encryption.cloudwatch_encryption_mode",
		"keyExpectedValue": "'cloudwatch_encryption_mode' should be set to 'SSE-KMS'",
		"keyActualValue": "'cloudwatch_encryption_mode' is not set to 'SSE-KMS'",
	}
} else = searchKeyInfo {
	config.job_bookmarks_encryption.job_bookmarks_encryption_mode != "CSE-KMS"
	searchKeyInfo := {
		"path": "encryption_configuration.job_bookmarks_encryption.job_bookmarks_encryption_mode",
		"keyExpectedValue": "'job_bookmarks_encryption_mode' should be set to 'CSE-KMS'",
		"keyActualValue": "'job_bookmarks_encryption_mode' is not set to 'CSE-KMS'",
	}
} else = searchKeyInfo {
	config.s3_encryption.s3_encryption_mode == "DISABLED"
	searchKeyInfo := {
		"path": "encryption_configuration.s3_encryption.s3_encryption_mode",
		"keyExpectedValue": "'s3_encryption_mode' should not be set to 'DISABLED'",
		"keyActualValue": "'s3_encryption_mode' is set to 'DISABLED'",
	}
}
