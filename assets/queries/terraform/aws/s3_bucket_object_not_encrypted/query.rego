package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_s3_bucket_object[name]
	not common_lib.valid_key(resource, "server_side_encryption")

	result := {
		"documentId": document.id,
		"resourceType": "aws_s3_bucket_object",
		"resourceName": tf_lib.get_specific_resource_name(resource, "aws_s3_bucket", name),
		"searchKey": sprintf("aws_s3_bucket_object[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_s3_bucket_object.server_side_encryption should be defined and not null",
		"keyActualValue": "aws_s3_bucket_object.server_side_encryption is undefined or null",
	}
}
