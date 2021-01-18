package Cx

#default of block_public_policy is false
CxPolicy[result] {
	pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
	object.get(pubACL, "block_public_policy", "not found") == "not found"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_public_access_block[%s].block_public_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'block_public_policy' is equal 'true'",
		"keyActualValue": "'block_public_policy' is missing",
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
	}
}
