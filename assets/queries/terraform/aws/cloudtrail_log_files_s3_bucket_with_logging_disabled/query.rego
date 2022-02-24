package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	terra_lib.is_deprecated_version(input.document)

	cloudtrail := input.document[_].resource.aws_cloudtrail[name]
	s3BucketName := split(cloudtrail.s3_bucket_name, ".")[1]

	bucket := input.document[i].resource.aws_s3_bucket[s3BucketName]
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
	logs := input.document[_].resource.aws_cloudtrail[name]
	s3BucketName := split(logs.s3_bucket_name, ".")[1]
	doc := input.document[i].module[moduleName]
	keyToCheck := common_lib.get_module_equivalent_key("aws", doc.source, "aws_s3_bucket", "logging")

	doc.bucket == s3BucketName
	not common_lib.valid_key(doc, keyToCheck)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [moduleName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'logging' is defined",
		"keyActualValue": "'logging' is undefined",
		"searchLine": common_lib.build_search_line(["module", moduleName], []),
	}
}

CxPolicy[result] {
	not terra_lib.is_deprecated_version(input.document)
	
	cloudtrail := input.document[_].resource.aws_cloudtrail[name]
	s3BucketName := split(cloudtrail.s3_bucket_name, ".")[1]

	bucket := input.document[i].resource.aws_s3_bucket[s3BucketName]
	not terra_lib.has_target_resource(s3BucketName, "aws_s3_bucket_logging")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [s3BucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_s3_bucket' has 'aws_s3_bucket_logging' associated",
		"keyActualValue": "'aws_s3_bucket' does not have 'aws_s3_bucket_logging' associated",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", s3BucketName], []),
	}
}
