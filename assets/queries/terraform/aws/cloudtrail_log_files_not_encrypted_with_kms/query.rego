package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	cloudtrail := input.document[i].resource.aws_cloudtrail[name]
	not common_lib.valid_key(cloudtrail, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudtrail",
		"resourceName": tf_lib.get_resource_name(cloudtrail, name),
		"searchKey": sprintf("aws_cloudtrail[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_cloudtrail[%s].kms_key_id should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_cloudtrail[%s].kms_key_id is undefined or null", [name]),
	}
}
