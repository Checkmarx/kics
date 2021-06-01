package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_sns_topic[name]

	uses_aws_maneged_key(resource.kms_master_key_id)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sns_topic[%s].kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "SNS Topic is not encrypted with AWS managed key",
		"keyActualValue": "SNS Topic is encrypted with AWS managed key",
	}
}

uses_aws_maneged_key(key) {
	key == "alias/aws/sns"
} else {
	keyName := split(key, ".")[2]
	kms := input.document[z].data.aws_kms_key[kmsName]
	keyName == kmsName
	kms.key_id == "alias/aws/sns"
}
