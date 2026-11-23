package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

is_unevaluated(content) {
	is_string(content)
	startswith(content, "${")
}

has_kms_key_id(content) {
	regex.match(`\bkmsKeyId\s*[=:]`, content)
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssm_document[name]

	resource.document_type == "Session"

	not is_unevaluated(resource.content)

	content := common_lib.get_policy(resource.content)
    not common_lib.valid_key(content, "inputs")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ssm_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssm_document[%s].content", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'inputs' should be defined and not null",
		"keyActualValue": "'inputs' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_document", name, "content"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssm_document[name]

	resource.document_type == "Session"

	not is_unevaluated(resource.content)

	content := common_lib.json_unmarshal(resource.content)
    not common_lib.valid_key(content.inputs, "kmsKeyId")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ssm_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssm_document[%s].content", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'inputs.kmsKeyId' should be defined and not null",
		"keyActualValue": "'inputs.kmsKeyId' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_document", name, "content"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssm_document[name]

	resource.document_type == "Session"

	is_unevaluated(resource.content)
	not has_kms_key_id(resource.content)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_ssm_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssm_document[%s].content", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'inputs.kmsKeyId' should be defined and not null",
		"keyActualValue": "'inputs.kmsKeyId' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_document", name, "content"], []),
	}
}
