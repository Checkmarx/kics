package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# Effective policy is the most restrictive of aws_s3_account_public_access_block and aws_s3_bucket_public_access_block
# Remediations are being applied only to aws_s3_bucket_public_access_block

CxPolicy[result] {
	pubACL := input.document[_].resource.aws_s3_account_public_access_block[_]
	pubBucket := input.document[i].resource.aws_s3_bucket_public_access_block[bucket_name]

	is_false_or_undefined(pubACL, "restrict_public_buckets")
	not common_lib.valid_key(pubBucket, "restrict_public_buckets")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubBucket, bucket_name),
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].restrict_public_buckets", [bucket_name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'restrict_public_buckets' should equal 'true'",
		"keyActualValue": "'restrict_public_buckets' is missing",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", bucket_name], []),
		"remediation": "restrict_public_buckets = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	pubACL := input.document[_].resource.aws_s3_account_public_access_block[_]
	pubBucket := input.document[i].resource.aws_s3_bucket_public_access_block[bucket_name]

	is_false_or_undefined(pubACL, "restrict_public_buckets")
	pubBucket.restrict_public_buckets == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubBucket, bucket_name),
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].restrict_public_buckets", [bucket_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'restrict_public_buckets' should equal 'true'",
		"keyActualValue": "'restrict_public_buckets' is equal to 'false'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", bucket_name, "restrict_public_buckets"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

is_false_or_undefined(obj, key) {
	not obj[key]
}
