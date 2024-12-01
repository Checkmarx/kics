package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

# version before TF AWS 4.0
CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_s3_bucket[name]
	publicAccessACL(resource.acl)

	result := {
		"documentId": document.id,
		"resourceType": "aws_s3_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("aws_s3_bucket[%s].acl=%s", [name, resource.acl]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'acl' should equal to 'private'",
		"keyActualValue": sprintf("'acl' is equal '%s'", [resource.acl]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "acl"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	module := document.module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "acl")

	publicAccessACL(module[keyToCheck])

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'acl' should equal to 'private'",
		"keyActualValue": sprintf("'acl' is equal '%s'", [module[keyToCheck]]),
		"searchLine": common_lib.build_search_line(["module", name, "acl"], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {
	input.document[_].resource.aws_s3_bucket[bucketName]
	some document in input.document
	acl := document.resource.aws_s3_bucket_acl[name]
	split(acl.bucket, ".")[1] == bucketName
	publicAccessACL(acl.acl)

	result := {
		"documentId": document.id,
		"resourceType": "aws_s3_bucket_acl",
		"resourceName": tf_lib.get_resource_name(acl, name),
		"searchKey": sprintf("aws_s3_bucket_acl[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket_acl[%s].acl should be private", [name]),
		"keyActualValue": sprintf("aws_s3_bucket_acl[%s].acl is %s", [acl.acl]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "acl"], []),
	}
}

publicAccessACL("public-read") = true

publicAccessACL("public-read-write") = true
