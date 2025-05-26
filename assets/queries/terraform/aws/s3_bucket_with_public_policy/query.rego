package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# checks if aws_s3_account_public_access_block and aws_s3_bucket_public_access_block resources exist
# checks if block_public_policy is set to false on bucket-level and account-level is set to false or missing
CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_account_public_access_block[account_name]
    pubBucket := input.document[i].resource.aws_s3_bucket_public_access_block[bucket_name]

    is_false_or_missing(pubACL,pubBucket)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_account_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubACL, account_name),
		"searchKey": sprintf("aws_s3_account_public_access_block[%s].block_public_policy", [account_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'block_public_policy' should be set to 'true' at both account and bucket level",
		"keyActualValue": "'block_public_policy' is missing or equal to 'false' at both account and bucket level",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_account_public_access_block", account_name, "block_public_policy"], []),
	}
}

is_false_or_missing(pubACL, pubBucket) {
    is_false_or_undefined(pubACL, "block_public_policy")
    is_false_or_undefined(pubBucket, "block_public_policy")
}

is_false_or_undefined(obj, key) {
    not obj[key]
}
