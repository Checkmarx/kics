package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudwatch_log_group[name]
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudwatch_log_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_cloudwatch_log_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'kms_key_id' should be set",
		"keyActualValue": "Attribute 'kms_key_id' is undefined",
	}
}
