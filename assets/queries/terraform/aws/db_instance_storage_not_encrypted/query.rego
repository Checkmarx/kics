package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
    object.get(resource,"storage_encrypted","undefined") != "undefined"
    not resource.storage_encrypted

	object.get(resource,"kms_key_id","undefined") == "undefined"

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
    object.get(resource,"storage_encrypted","undefined") == "undefined"

	object.get(resource,"kms_key_id","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_db_instance.storage_encrypted' is set",
		"keyActualValue": "'aws_db_instance.storage_encrypted' is undefined",
	}
}
