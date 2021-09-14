package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssm_document[name]

	resource.document_type == "Session"

	content := common_lib.json_unmarshal(resource.content)
    not common_lib.valid_key(content, "inputs")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ssm_document[%s].content", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'inputs' is defined and not null",
		"keyActualValue": "'inputs' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_document", name, "content"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_ssm_document[name]

	resource.document_type == "Session"

	content := common_lib.json_unmarshal(resource.content)
    not common_lib.valid_key(content.inputs, "kmsKeyId")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ssm_document[%s].content", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'inputs.kmsKeyId' is defined and not null",
		"keyActualValue": "'inputs.kmsKeyId' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_ssm_document", name, "content"], []),
	}
}
