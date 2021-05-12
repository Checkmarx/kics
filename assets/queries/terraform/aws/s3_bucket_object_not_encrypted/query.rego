package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket_object[name]
	object.get(resource, "server_side_encryption", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_object[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_s3_bucket_object.server_side_encryption is defined",
		"keyActualValue": "aws_s3_bucket_object.server_side_encryption is missing",
	}
}
