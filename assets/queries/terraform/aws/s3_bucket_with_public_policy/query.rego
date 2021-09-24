package Cx

import data.generic.common as common_lib

#default of block_public_policy is false
CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	not common_lib.valid_key(pubACL, "block_public_policy")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].block_public_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'block_public_policy' is equal 'true'",
		"keyActualValue": "'block_public_policy' is missing",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name], []),
	}
}

CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	pubACL.block_public_policy == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].block_public_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'block_public_policy' is equal 'true'",
		"keyActualValue": "'block_public_policy' is equal 'false'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name, "block_public_policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "block_public_policy")
	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'block_public_policy' is equal 'true'",
		"keyActualValue": "'block_public_policy' is missing",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "block_public_policy")
	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'block_public_policy' is equal 'true'",
		"keyActualValue": "'block_public_policy' is equal 'false'",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}
