package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	publicAccessACL(resource.acl)

	publicBlockACL := input.document[j].resource.aws_s3_bucket_public_access_block[blockName]

	split(publicBlockACL.bucket, ".")[1] == name

	publicBlockACL.block_public_acls == true
	publicBlockACL.block_public_policy == true
	publicBlockACL.ignore_public_acls == true
	publicBlockACL.restrict_public_buckets == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 Bucket public ACL is not overridden by S3 bucket Public Access Block",
		"keyActualValue": "S3 Bucket public ACL is overridden by S3 bucket Public Access Block",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "acl"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket[name]
	publicAccessACL(resource.acl)

	module := input.document[j].module[moduleName]

	bucket := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "bucket")
	split(module[bucket], ".")[1] == name

	blockACL := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "block_public_acls")
	blockPolicy := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "block_public_policy")
	ignoreACL := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "ignore_public_acls")
	restrictBuckets := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "restrict_public_buckets")

	module[blockACL] == true
	module[blockPolicy] == true
	module[ignoreACL] == true
	module[restrictBuckets] == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 Bucket public ACL is not overridden by S3 bucket Public Access Block",
		"keyActualValue": "S3 Bucket public ACL is overridden by S3 bucket Public Access Block",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "acl"], []),
	}
}

publicAccessACL("public-read") = true

publicAccessACL("public-read-write") = true
