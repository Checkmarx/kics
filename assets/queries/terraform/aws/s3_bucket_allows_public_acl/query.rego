package Cx

import data.generic.common as common_lib

#default of block_public_acls is false
CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	not common_lib.valid_key(pubACL, "block_public_acls")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].block_public_acls", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'block_public_acls' is equal 'true'",
		"keyActualValue": "'block_public_acls' is missing",
	}
}

CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	pubACL.block_public_acls == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].block_public_acls", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'block_public_acls' is equal 'true'",
		"keyActualValue": "'block_public_acls' is equal 'false'",
	}
}
