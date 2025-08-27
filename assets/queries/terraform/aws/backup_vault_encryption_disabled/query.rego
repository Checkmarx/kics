package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	vault := input.document[i].resource.aws_backup_vault[name]
	common_lib.valid_key(vault, "kms_key_arn") == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_backup_vault",
		"resourceName": tf_lib.get_resource_name(vault, name),
		"searchKey": sprintf("aws_backup_vault[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_backup_vault", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kms_key_arn' should be defined",
		"keyActualValue": "'kms_key_arn' is not defined",
	}
}
