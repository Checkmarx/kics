package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	cloudtrail := input.document[i].resource.aws_cloudtrail[name]

	s3BucketName := split(cloudtrail.s3_bucket_name, ".")[1]

	bucket := input.document[_].resource.aws_s3_bucket[s3BucketName]
	not common_lib.valid_key(bucket, "logging")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [s3BucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s] has 'logging' defined", [s3BucketName]),
		"keyActualValue": sprintf("aws_s3_bucket[%s] does not have 'logging' defined", [s3BucketName]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", s3BucketName], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "logging")
	s3BucketName := split(module.s3_bucket_name, ".")[1]

	bucket := input.document[_].module[s3BucketName]
	not common_lib.valid_key(bucket, "logging")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [s3BucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'logging' is defined",
		"keyActualValue": "'logging' is undefined",
		"searchLine": common_lib.build_search_line(["module", s3BucketName], []),
	}
}
