package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_secretsmanager_secret[name]
	object.get(resource, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_secretsmanager_secret[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_secretsmanager_secret.kms_key_id is defined",
		"keyActualValue": "aws_secretsmanager_secret.kms_key_id is missing",
	}
}
