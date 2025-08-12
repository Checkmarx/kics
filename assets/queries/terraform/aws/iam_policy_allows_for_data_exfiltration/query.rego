package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

ilegal_actions := ["s3:GetObject", "ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath", "secretsmanager:GetSecretValue","*","s3:*"]

CxPolicy[result] {
	resource := input.document[i].resource["aws_iam_policy"][name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[st_index]
	common_lib.is_allow_effect(statement)
    ilegal_action := is_ilegal(statement.Action)
	ilegal_action != "none"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.policy.Statement.Action[%d]' shouldn't contain ilegal actions",[name,st_index]),
		"keyActualValue": sprintf("'%s.policy.Statement.Action[%d]' contains [%s]",[name,st_index,ilegal_action]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_policy", name, "policy"], []),
		"searchValue" : sprintf("%s",[ilegal_action]),
	}
}

is_ilegal(Action) = Action {
	is_string(Action)
	Action == ilegal_actions[_]
} else = res {
	is_array(Action)
	illegal_actions_list := [a |
    	a := Action[_]
    	ilegal_actions[_] == a
	]
	res := concat(", ", illegal_actions_list)
	res != ""
} else = "none"
