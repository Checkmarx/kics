package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Bucket-level: BlockPublicPolicy missing
CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	not common_lib.valid_key(resource, "block_public_policy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_s3_bucket_public_access_block[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_s3_bucket_public_access_block[{{%s}}].block_public_policy' should be defined to true", [name]),
		"keyActualValue": sprintf("'aws_s3_bucket_public_access_block[{{%s}}].block_public_policy' is not defined (defaults to false)", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name], []),
	}
}

# Bucket-level: BlockPublicPolicy false
CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	common_lib.valid_key(resource, "block_public_policy")
	resource.block_public_policy == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_s3_bucket_public_access_block[{{%s}}].block_public_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_s3_bucket_public_access_block[{{%s}}].block_public_policy' should be defined to true", [name]),
		"keyActualValue": sprintf("'aws_s3_bucket_public_access_block[{{%s}}].block_public_policy' is defined to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name, "block_public_policy"], []),
	}
}

# Account-level: BlockPublicPolicy missing
CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_account_public_access_block[name]
	not common_lib.valid_key(resource, "block_public_policy")
	# avoid duplicate/noisy findings when bucket-level configuration exists
	not common_lib.valid_key(input.document[i].resource, "aws_s3_bucket_public_access_block")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_account_public_access_block",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_s3_account_public_access_block[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_s3_account_public_access_block[{{%s}}].block_public_policy' should be defined to true", [name]),
		"keyActualValue": sprintf("'aws_s3_account_public_access_block[{{%s}}].block_public_policy' is not defined (defaults to false)", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_account_public_access_block", name], []),
	}
}

# Account-level: BlockPublicPolicy false
CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_account_public_access_block[name]
	common_lib.valid_key(resource, "block_public_policy")
	resource.block_public_policy == false
	# avoid duplicate/noisy findings when bucket-level configuration exists
	not common_lib.valid_key(input.document[i].resource, "aws_s3_bucket_public_access_block")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_account_public_access_block",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_s3_account_public_access_block[{{%s}}].block_public_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_s3_account_public_access_block[{{%s}}].block_public_policy' should be defined to true", [name]),
		"keyActualValue": sprintf("'aws_s3_account_public_access_block[{{%s}}].block_public_policy' is defined to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_account_public_access_block", name, "block_public_policy"], []),
	}
}