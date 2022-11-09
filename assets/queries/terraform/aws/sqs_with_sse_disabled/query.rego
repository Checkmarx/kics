package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

## two ways to activated SSE : kms_master_key_id OR sqs_managed_sse_enabled
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue#server-side-encryption-sse
sse_activated(obj) {
    common_lib.valid_key(obj, "kms_master_key_id")
} else {
    common_lib.valid_key(obj, "sqs_managed_sse_enabled")
} else = false {
	true
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]
	not common_lib.valid_key(resource, "kms_master_key_id")

	resource.sqs_managed_sse_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_sqs_queue",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sqs_queue[%s].sqs_managed_sse_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_sqs_queue[%s].sqs_managed_sse_enabled must be set to true", [name]),
		"keyActualValue": sprintf("aws_sqs_queue[%s].sqs_managed_sse_enabled is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue", name, "sqs_managed_sse_enabled"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]
	sse_activated(resource) == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_sqs_queue",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sqs_queue[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_sqs_queue[%s].kms_master_key_id or aws_sqs_queue[%s].sqs_managed_sse_enabled should be defined and not null", [name, name]),
		"keyActualValue": sprintf("aws_sqs_queue[%s].kms_master_key_id and aws_sqs_queue[%s].sqs_managed_sse_enabled are undefined or null", [name, name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sqs_queue", "kms_master_key_id")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kms_master_key_id' should be defined and not null",
		"keyActualValue": "'kms_master_key_id' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]
	resource.kms_master_key_id == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_sqs_queue",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sqs_queue[%s].kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_sqs_queue.kms_master_key_id should not be ''",
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
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'kms_master_key_id' should not be empty",
		"keyActualValue": "'kms_master_key_id' is empty",
		"searchLine": common_lib.build_search_line(["module", name, "kms_master_key_id"], []),
	}
}
