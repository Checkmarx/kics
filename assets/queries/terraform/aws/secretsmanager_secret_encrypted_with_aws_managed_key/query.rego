package Cx

import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_secretsmanager_secret[name]

	terraLib.uses_aws_managed_key(resource.kms_key_id, "alias/aws/secretsmanager")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_secretsmanager_secret[%s].kms_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Secrets Manager secret is not encrypted with AWS managed key",
		"keyActualValue": "Secrets Manager secret is encrypted with AWS managed key",
	}
}
