package Cx

import data.generic.common as common_lib

publicAcl := {"public-read", "public-read-write"}

CxPolicy[result] {
	cloudtrail := input.document[i].resource.aws_cloudtrail[name]

	s3BucketName := split(cloudtrail.s3_bucket_name, ".")[1]

	bucket := input.document[_].resource.aws_s3_bucket[s3BucketName]

	bucket.acl == publicAcl[_]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].acl", [s3BucketName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s] is not publicly accessible", [s3BucketName]),
		"keyActualValue": sprintf("aws_s3_bucket[%s] is publicly accessible", [s3BucketName]),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "acl")

	module[keyToCheck] == publicAcl[_]
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s] is not publicly accessible", [name]),
		"keyActualValue": sprintf("module[%s] is publicly accessible", [name]),
	}
}
