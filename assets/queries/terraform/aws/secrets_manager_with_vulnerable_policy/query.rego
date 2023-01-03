package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_secretsmanager_secret_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	not common_lib.valid_key(statement, "Condition")
	common_lib.has_wildcard(statement, "secretsmanager:*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_secretsmanager_secret_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_secretsmanager_secret_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_secretsmanager_secret_policy[%s].policy should not have wildcard in 'Principal' and 'Action'", [name]),
		"keyActualValue": sprintf("aws_secretsmanager_secret_policy[%s].policy has wildcard in 'Principal' or 'Action'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_secretsmanager_secret_policy", name, "policy"], []),
	}
}
