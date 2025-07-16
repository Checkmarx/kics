package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	s3 := input.document[i].resource.aws_s3_bucket[bucketName]

	not common_lib.valid_key(s3, "logging") # version before TF AWS 4.0
	not tf_lib.has_target_resource(bucketName, "aws_s3_bucket_logging") # version after TF AWS 4.0
	not has_associated_logging(bucketName, input.document[i])

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(s3, "aws_s3_bucket", bucketName),
		"searchKey": sprintf("aws_s3_bucket[%s]", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'logging' should be defined and not null",
		"keyActualValue": "'logging' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", bucketName], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "logging")
	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'logging' should be defined and not null",
		"keyActualValue": "'logging' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

has_associated_logging(aws_s3_bucket_name, doc) {
	[_, value] := walk(doc)
	bucket_logging := value.aws_s3_bucket_logging[_]
	contains(bucket_logging.bucket, sprintf("aws_s3_bucket.%s", [aws_s3_bucket_name]))
}
