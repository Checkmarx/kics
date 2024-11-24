package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_sns_topic[name]

	tf_lib.uses_aws_managed_key(resource.kms_master_key_id, "alias/aws/sns")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_sns_topic",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sns_topic[%s].kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "SNS Topic should not be encrypted with AWS managed key",
		"keyActualValue": "SNS Topic is encrypted with AWS managed key",
	}
}
