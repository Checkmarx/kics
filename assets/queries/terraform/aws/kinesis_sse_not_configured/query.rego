package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]

	resource.kinesis_source_configuration
	not resource.kinesis_source_configuration.kinesis_stream_arn
	resource.server_side_encryption.enabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kinesis_firehose_delivery_stream",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'server_side_encryption' should be enabled and attribute 'kinesis_source_configuration' should be undefined",
		"keyActualValue": "Attribute 'server_side_encryption' is enabled and attribute 'kinesis_source_configuration' is set",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]

	not resource.server_side_encryption
	not resource.kinesis_source_configuration.kinesis_stream_arn

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kinesis_firehose_delivery_stream",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kinesis_firehose_delivery_stream[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'server_side_encryption' should be set",
		"keyActualValue": "Attribute 'server_side_encryption' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]

	not resource.kinesis_source_configuration

	resource.server_side_encryption
	resource.server_side_encryption.enabled != true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kinesis_firehose_delivery_stream",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'server_side_encryption' should be enabled",
		"keyActualValue": "Attribute 'server_side_encryption' is not enabled",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]

	not resource.kinesis_source_configuration

	resource.server_side_encryption.enabled == true

	key_type := resource.server_side_encryption.key_type

	not validKeyType(key_type)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kinesis_firehose_delivery_stream",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption.key_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'key_type' should be valid",
		"keyActualValue": "Attribute 'key_type' is invalid",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kinesis_firehose_delivery_stream[name]

	not resource.kinesis_source_configuration

	resource.server_side_encryption.enabled == true

	key_type := resource.server_side_encryption.key_type

	key_type == "CUSTOMER_MANAGED_CMK"

	not resource.server_side_encryption.key_arn

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_kinesis_firehose_delivery_stream",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_kinesis_firehose_delivery_stream[%s].server_side_encryption", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'key_type' should be CUSTOMER_MANAGED_CMK and attribute 'key_arn' should be set",
		"keyActualValue": "Attribute 'key_type' is CUSTOMER_MANAGED_CMK and attribute 'key_arn' is undefined",
	}
}

validKeyType("AWS_OWNED_CMK") = true

validKeyType("CUSTOMER_MANAGED_CMK") = true
