package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]

	resource.storage_encrypted == false

	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s].storage_encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'storage_encrypted' should be set to true",
		"keyActualValue": "'storage_encrypted' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "storage_encrypted"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck1 := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "storage_encrypted")
	keyToCheck2 := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "kms_key_id")

	module[keyToCheck1] == false
	not common_lib.valid_key(module, keyToCheck2)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].storage_encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'storage_encrypted' should be set to true",
		"keyActualValue": "'storage_encrypted' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "storage_encrypted"], []),
	}
}


CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]

	not common_lib.valid_key(resource, "storage_encrypted")
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'storage_encrypted' should be set to true",
		"keyActualValue": "'storage_encrypted' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
	}
}


CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck1 := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "storage_encrypted")
	keyToCheck2 := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "kms_key_id")

	not common_lib.valid_key(module, keyToCheck1)
	not common_lib.valid_key(module, keyToCheck2)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'storage_encrypted' should be set to true",
		"keyActualValue": "'storage_encrypted' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}
