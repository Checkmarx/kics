package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)

	resource := input.document[i].resource.aws_s3_bucket[name]
	publicAccessACL(resource.acl)

	publicBlockACL := input.document[_].resource.aws_s3_bucket_public_access_block[blockName]

	split(publicBlockACL.bucket, ".")[1] == name

	public(publicBlockACL)

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
	module := input.document[i].module[name]
	keyToCheckAcl := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket_public_access_block", "acl")

	publicAccessACL(module[keyToCheckAcl])

	options = {"block_public_acls", "block_public_policy", "ignore_public_acls", "restrict_public_buckets"}

	count({x | keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket_public_access_block", options[x]);
			   module[keyToCheck] == true }) == 4

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 Bucket public ACL is not overridden by public access block",
		"keyActualValue": "S3 Bucket public ACL is overridden by public access block",
		"searchLine": common_lib.build_search_line(["module", name, "acl"], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)

	input.document[_].resource.aws_s3_bucket[bucketName]

	acl := input.document[i].resource.aws_s3_bucket_acl[name]
	split(acl.bucket, ".")[1] == bucketName

	publicAccessACL(acl.acl)

	publicBlockACL := input.document[_].resource.aws_s3_bucket_public_access_block[blockName]
	split(publicBlockACL.bucket, ".")[1] == bucketName

	public(publicBlockACL)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_acl[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "S3 Bucket public ACL is not overridden by S3 bucket Public Access Block",
		"keyActualValue": "S3 Bucket public ACL is overridden by S3 bucket Public Access Block",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "acl"], []),
	}
}

publicAccessACL("public-read") = true

publicAccessACL("public-read-write") = true

public(publicBlockACL) {
	publicBlockACL.block_public_acls == true
	publicBlockACL.block_public_policy == true
	publicBlockACL.ignore_public_acls == true
	publicBlockACL.restrict_public_buckets == true
}
