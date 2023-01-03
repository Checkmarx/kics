package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

#default of block_public_acls is false
CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	not common_lib.valid_key(pubACL, "block_public_acls")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubACL, name),
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'block_public_acls' should equal 'true'",
		"keyActualValue": "'block_public_acls' is missing",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name], []),
		"remediation": "block_public_acls = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	pubACL.block_public_acls == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_s3_bucket_public_access_block",
		"resourceName": tf_lib.get_resource_name(pubACL, name),
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].block_public_acls", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'block_public_acls' should equal 'true'",
		"keyActualValue": "'block_public_acls' is equal 'false'",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket_public_access_block", name, "block_public_acls"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "block_public_acls")
	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'block_public_acls' should equal 'true'",
		"keyActualValue": "'block_public_acls' is missing",
		"searchLine": common_lib.build_search_line(["module", name], []),
		"remediation": sprintf("%s = true", [keyToCheck]),
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "block_public_acls")
	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'block_public_acls' should equal 'true'",
		"keyActualValue": "'block_public_acls' is equal 'false'",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
