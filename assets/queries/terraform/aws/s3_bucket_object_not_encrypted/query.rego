package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_s3_bucket_object[name]
	not common_lib.valid_key(resource, "server_side_encryption")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket_object[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_s3_bucket_object.server_side_encryption is defined and not null",
		"keyActualValue": "aws_s3_bucket_object.server_side_encryption is undefined or null",
	}
}
