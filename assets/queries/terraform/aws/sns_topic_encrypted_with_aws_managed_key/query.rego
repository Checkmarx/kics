package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sns_topic[name]

	terraLib.uses_aws_managed_key(resource.kms_master_key_id, "alias/aws/sns")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sns_topic[%s].kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "SNS Topic is not encrypted with AWS managed key",
		"keyActualValue": "SNS Topic is encrypted with AWS managed key",
	}
}
