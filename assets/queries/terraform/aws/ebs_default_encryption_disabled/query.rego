package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ebs_encryption_by_default[name]
	resource.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ebs_encryption_by_default",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ebs_encryption_by_default[%s].enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_ebs_encryption_by_default.encrypted' is true",
		"keyActualValue": "'aws_ebs_encryption_by_default.encrypted' is false",
	}
}
