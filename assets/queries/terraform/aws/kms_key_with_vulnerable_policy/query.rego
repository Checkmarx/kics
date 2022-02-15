package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	not common_lib.valid_key(statement, "Condition")
	common_lib.has_wildcard(statement, "kms:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kms_key[%s].policy does not have wildcard in 'Action' and 'Principal'", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].policy has wildcard in 'Action' or 'Principal'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_kms_key", name, "policy"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	not common_lib.valid_key(resource, "policy")
	
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kms_key[%s].policy is defined and not null", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].policy is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_kms_key", name], []),
	}
}

