package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]
	not common_lib.valid_key(resource, "kms_master_key_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_sqs_queue.kms_master_key_id is defined and not null",
		"keyActualValue": "aws_sqs_queue.kms_master_key_id is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sqs_queue", "kms_master_key_id")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kms_master_key_id' is defined and not null",
		"keyActualValue": "'kms_master_key_id' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]
	resource.kms_master_key_id == ""

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue[%s].kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_sqs_queue.kms_master_key_id is not ''",
		"keyActualValue": "aws_sqs_queue.kms_master_key_id is ''",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue", name, "kms_master_key_id"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sqs_queue", "kms_master_key_id")

	module[keyToCheck] == ""

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'kms_master_key_id' is defined and not null",
		"keyActualValue": "'kms_master_key_id' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name, "kms_master_key_id"], []),
	}
}
