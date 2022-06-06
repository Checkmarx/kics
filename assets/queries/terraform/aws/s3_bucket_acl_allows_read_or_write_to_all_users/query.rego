package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

# version before TF AWS 4.0
CxPolicy[result] {

	resource := input.document[i].resource.aws_s3_bucket[name]
	publicAccessACL(resource.acl)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].acl=%s", [name, resource.acl]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'acl' to be equal to 'private'",
		"keyActualValue": sprintf("'acl' is equal '%s'", [resource.acl]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name, "acl"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "acl")

	publicAccessACL(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'acl' to be equal to 'private'",
		"keyActualValue": sprintf("'acl' is equal '%s'", [module[keyToCheck]]),
		"searchLine": common_lib.build_search_line(["module", name, "acl"], []),
	}
}

# version after TF AWS 4.0
CxPolicy[result] {

	input.document[_].resource.aws_s3_bucket[bucketName]
	acl := input.document[i].resource.aws_s3_bucket_acl[name]
	split(acl.bucket, ".")[1] == bucketName
	publicAccessACL(acl.acl)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_acl[%s].acl", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket_acl[%s].acl to be private", [name]),
		"keyActualValue": sprintf("aws_s3_bucket_acl[%s].acl is %s", [acl.acl]),
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_acl", name, "acl"], []),
	}
}


publicAccessACL("public-read") = true

publicAccessACL("public-read-write") = true
