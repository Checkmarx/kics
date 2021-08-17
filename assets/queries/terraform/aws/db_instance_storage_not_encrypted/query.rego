package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]

	resource.storage_encrypted == false

	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].storage_encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_db_instance.storage_encrypted' is true",
		"keyActualValue": "'aws_db_instance.storage_encrypted' is false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]

	not common_lib.valid_key(resource, "storage_encrypted")
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_db_instance.storage_encrypted' is set",
		"keyActualValue": "'aws_db_instance.storage_encrypted' is undefined",
	}
}
