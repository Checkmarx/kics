package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_ssm_document[name]

	resource.document_type == "Session"

	content := common_lib.json_unmarshal(resource.content)
	not common_lib.valid_key(content, "inputs")

	result := {
		"documentId": doc.id,
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
	some doc in input.document
	resource := doc.resource.aws_ssm_document[name]

	resource.document_type == "Session"

	content := common_lib.json_unmarshal(resource.content)
	not common_lib.valid_key(content.inputs, "kmsKeyId")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_ssm_document",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_ssm_document[%s].content", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'inputs.kmsKeyId' should be defined and not null",
		"keyActualValue": "'inputs.kmsKeyId' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_document", name, "content"], []),
	}
}
