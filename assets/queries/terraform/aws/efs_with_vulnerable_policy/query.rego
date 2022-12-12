package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_efs_file_system_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	not common_lib.valid_key(statement, "Condition")
	common_lib.has_wildcard(statement, "elasticfilesystem:*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_efs_file_system_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_efs_file_system_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_efs_file_system_policy[%s].policy should not have wildcard in 'Action' and 'Principal'", [name]),
		"keyActualValue": sprintf("aws_efs_file_system_policy[%s].policy has wildcard in 'Action' or 'Principal'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_efs_file_system_policy", name, "policy"], []),
	}
}
