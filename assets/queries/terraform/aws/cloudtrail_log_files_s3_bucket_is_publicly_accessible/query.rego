package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

publicAcl := {"public-read", "public-read-write"}

# version before TF AWS 4.0
CxPolicy[result] {

	cloudtrail := input.document[_].resource.aws_cloudtrail[name]
	s3BucketName := split(cloudtrail.s3_bucket_name, ".")[1]
	bucket := input.document[i].resource.aws_s3_bucket[s3BucketName]
	bucket.acl == publicAcl[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(bucket, "aws_s3_bucket", s3BucketName),
		"searchKey": sprintf("aws_s3_bucket[%s].acl", [s3BucketName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s] to not be publicly accessible", [s3BucketName]),
		"keyActualValue": sprintf("aws_s3_bucket[%s] is publicly accessible", [s3BucketName]),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "acl")

	module[keyToCheck] == publicAcl[_]
	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s] to not be publicly accessible", [name]),
		"keyActualValue": sprintf("module[%s] is publicly accessible", [name]),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {

	cloudtrail := input.document[_].resource.aws_cloudtrail[name]
	s3BucketName := split(cloudtrail.s3_bucket_name, ".")[1]
	input.document[_].resource.aws_s3_bucket[s3BucketName]
	acl := input.document[i].resource.aws_s3_bucket_acl[name]
	split(acl.bucket, ".")[1] == s3BucketName
	acl.acl == publicAcl[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_resource_name(acl, name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket_acl[%s] to not be publicly accessible", [name]),
		"keyActualValue": sprintf("aws_s3_bucket_acl[%s] is publicly accessible", [name]),
	}
}
