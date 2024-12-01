package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_efs_file_system_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	some statement in st

	common_lib.is_allow_effect(statement)
	not common_lib.valid_key(statement, "Condition")
	common_lib.has_wildcard(statement, "elasticfilesystem:*")

	result := {
		"documentId": document.id,
		"resourceType": "aws_efs_file_system_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_efs_file_system_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_efs_file_system_policy[%s].policy should not have wildcard in 'Action' and 'Principal'", [name]),
		"keyActualValue": sprintf("aws_efs_file_system_policy[%s].policy has wildcard in 'Action' or 'Principal'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_efs_file_system_policy", name, "policy"], []),
	}
}
