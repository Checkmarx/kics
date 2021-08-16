package Cx

import data.generic.terraform as terraLib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sns_topic[name]

	not common_lib.valid_key(resource, "kms_master_key_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sns_topic[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "SNS Topic is encrypted",
		"keyActualValue": "SNS Topic is not encrypted",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_sns_topic[name]

	resource.kms_master_key_id == ""

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sns_topic[%s].kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "SNS Topic is encrypted",
		"keyActualValue": "SNS Topic is not encrypted",
	}
}
