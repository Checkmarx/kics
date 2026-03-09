package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_backup_vault[name]
	not common_lib.valid_key(resource, "kms_key_arn")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_backup_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_backup_vault[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_backup_vault[%s].kms_key_arn' should be defined", [name]),
		"keyActualValue": sprintf("'aws_backup_vault[%s].kms_key_arn' is not defined; vault uses AWS-managed key", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_backup_vault", name], []),
		"remediation": "kms_key_arn = aws_kms_key.example.arn",
		"remediationType": "addition",
	}
}
