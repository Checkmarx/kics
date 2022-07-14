package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_secretsmanager_secret[name]

	tf_lib.uses_aws_managed_key(resource.kms_key_id, "alias/aws/secretsmanager")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_secretsmanager_secret",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_secretsmanager_secret[%s].kms_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Secrets Manager secret should not be encrypted with AWS managed key",
		"keyActualValue": "Secrets Manager secret is encrypted with AWS managed key",
	}
}
