package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_glue_data_catalog_encryption_settings[name]

	resource.data_catalog_encryption_settings.encryption_at_rest.catalog_encryption_mode != "SSE-KMS"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_glue_data_catalog_encryption_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_glue_data_catalog_encryption_settings[%s].data_catalog_encryption_settings.encryption_at_rest.catalog_encryption_mode", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'catalog_encryption_mode' should be set to 'SSE-KMS'",
		"keyActualValue": "'catalog_encryption_mode' is not set to 'SSE-KMS'",
		"searchLine": common_lib.build_search_line(["resource", "aws_glue_data_catalog_encryption_settings", name, "data_catalog_encryption_settings","encryption_at_rest", "catalog_encryption_mode"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_glue_data_catalog_encryption_settings[name]

	not common_lib.valid_key(resource.data_catalog_encryption_settings.encryption_at_rest, "sse_aws_kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_glue_data_catalog_encryption_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_glue_data_catalog_encryption_settings[%s].data_catalog_encryption_settings.encryption_at_rest", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'sse_aws_kms_key_id' should be defined and not null",
		"keyActualValue": "'sse_aws_kms_key_id' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_glue_data_catalog_encryption_settings", name, "data_catalog_encryption_settings","encryption_at_rest"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_glue_data_catalog_encryption_settings[name]

	resource.data_catalog_encryption_settings.connection_password_encryption.return_connection_password_encrypted != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_glue_data_catalog_encryption_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_glue_data_catalog_encryption_settings[%s].data_catalog_encryption_settings.connection_password_encryption.return_connection_password_encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'return_connection_password_encrypted' should be set to true",
		"keyActualValue": "'return_connection_password_encrypted' is not set to true",
		"searchLine": common_lib.build_search_line(["resource", "aws_glue_data_catalog_encryption_settings", name, "data_catalog_encryption_settings","connection_password_encryption", "return_connection_password_encrypted"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_glue_data_catalog_encryption_settings[name]

	not common_lib.valid_key(resource.data_catalog_encryption_settings.connection_password_encryption, "aws_kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_glue_data_catalog_encryption_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_glue_data_catalog_encryption_settings[%s].data_catalog_encryption_settings.connection_password_encryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_kms_key_id' should be defined and not null",
		"keyActualValue": "'aws_kms_key_id' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_glue_data_catalog_encryption_settings", name, "data_catalog_encryption_settings","connection_password_encryption"], []),

	}
}
