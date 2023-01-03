package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_secretsmanager_secret[name]
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_secretsmanager_secret",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_secretsmanager_secret[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_secretsmanager_secret.kms_key_id should be defined and not null",
		"keyActualValue": "aws_secretsmanager_secret.kms_key_id is undefined or null",
	}
}
