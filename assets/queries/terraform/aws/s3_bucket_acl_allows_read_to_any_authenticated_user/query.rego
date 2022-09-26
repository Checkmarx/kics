package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# version before TF AWS 4.0
CxPolicy[result] {
	
	resource := input.document[i].resource.aws_s3_bucket[name]
	resource.acl == "authenticated-read"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("aws_s3_bucket[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s].acl should be private", [name]),
		"keyActualValue": sprintf("aws_s3_bucket[%s].acl is authenticated-read", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "acl"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "acl")

	module[keyToCheck] == "authenticated-read"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'acl' should be private",
		"keyActualValue": "'acl' is authenticated-read",
		"searchLine": common_lib.build_search_line(["module", name, "acl"], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	
	input.document[_].resource.aws_s3_bucket[bucketName]
	acl := input.document[i].resource.aws_s3_bucket_acl[name]
	split(acl.bucket, ".")[1] == bucketName
	acl.acl == "authenticated-read"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_resource_name(acl, name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket_acl[%s].acl should be private", [name]),
		"keyActualValue": sprintf("aws_s3_bucket_acl[%s].acl is authenticated-read", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "acl"], []),
	}
}
