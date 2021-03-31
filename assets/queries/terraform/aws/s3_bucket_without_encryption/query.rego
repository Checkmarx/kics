package Cx

#default of block_public_policy is false
CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]
	sse := bucket.server_side_encryption_configuration.rule.apply_server_side_encryption_by_default

	sse.sse_algorithm != "AE256"
	object.get(sse, "kms_master_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.kms_master_key_id' exists",
		"keyActualValue": "'server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.kms_master_key_id' is missing",
	}
}

CxPolicy[result] {
	bucket := input.document[i].resource.aws_s3_bucket[name]
	object.get(bucket, "server_side_encryption_configuration", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_s3_bucket.server_side_encryption_configuration' exists",
		"keyActualValue": "'aws_s3_bucket.server_side_encryption_configuration' is missing",
	}
}
