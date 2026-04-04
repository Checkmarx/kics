package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

illegal_actions := ["s3:GetObject", "ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath", "secretsmanager:GetSecretValue","*","s3:*"]

CxPolicy[result] { # resources
	resourceType := {"aws_iam_policy", "aws_iam_group_policy", "aws_iam_user_policy", "aws_iam_role_policy"}
	resource := input.document[i].resource[resourceType[idx]][name]

	policy := common_lib.get_policy(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[st_index]
	common_lib.is_allow_effect(statement)
    illegal_action := is_illegal(statement.Action)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].policy", [resourceType[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.policy.Statement.Action[%d]' shouldn't contain illegal actions",[name,st_index]),
		"keyActualValue": sprintf("'%s.policy.Statement.Action[%d]' contains [%s]",[name,st_index,illegal_action]),
		"searchLine": common_lib.build_search_line(["resource", resourceType[idx], name, "policy"], []),
		"searchValue" : sprintf("%s",[illegal_action]),
	}
}

CxPolicy[result] { # modules
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_iam_policy", "policy")

	policy := common_lib.get_policy(module[keyToCheck])
	st := common_lib.get_statement(policy)
	statement := st[st_index]
	common_lib.is_allow_effect(statement)
	illegal_action := is_illegal(statement.Action)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("%s.policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.policy.Statement.Action[%d]' shouldn't contain illegal actions",[name,st_index]),
		"keyActualValue": sprintf("'%s.policy.Statement.Action[%d]' contains [%s]",[name,st_index,illegal_action]),
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
		"searchValue" : sprintf("%s",[illegal_action]),
	}
}

CxPolicy[result] { # data source
	data_res := input.document[i].data.aws_iam_policy_document[name]

	statement_array := get_as_list(data_res.statement)
	res := prepare_issue_data_source(statement_array.value[index], name, index, statement_array.is_unique_element)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy_document",
		"resourceName": name,
		"searchKey": res["sk"],
		"issueType": "IncorrectValue",
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
		"searchValue": res["sv"],
	}
}

prepare_issue_data_source(statement, name, index, is_unique_element) = res {
	not is_unique_element
	common_lib.is_allow_effect(statement)
    illegal_action := is_illegal(statement.actions)

	res := {
		"sk": sprintf("aws_iam_policy_document[%s].statement[%d].actions", [name, index]),
		"kev": sprintf("'aws_iam_policy_document[%s].statement[%d].actions' shouldn't contain illegal actions", [name, index]),
		"kav": sprintf("'aws_iam_policy_document[%s].statement[%d].actions' contains [%s]", [name, index, illegal_action]),
		"sl": common_lib.build_search_line(["data", "aws_iam_policy_document", name, "statement", index, "actions"], []),
		"sv": sprintf("%s", [illegal_action]),
	}
} else = res {
	is_unique_element
	common_lib.is_allow_effect(statement)
	illegal_action := is_illegal(statement.actions)

	res := {
		"sk": sprintf("aws_iam_policy_document[%s].statement.actions", [name]),
		"kev": sprintf("'aws_iam_policy_document[%s].statement.actions' shouldn't contain illegal actions", [name]),
		"kav": sprintf("'aws_iam_policy_document[%s].statement.actions' contains [%s]", [name, illegal_action]),
		"sl": common_lib.build_search_line(["data", "aws_iam_policy_document", name, "statement", "actions"], []),
		"sv": sprintf("%s", [illegal_action]),
	}
}

get_as_list(statements) = result {
	is_array(statements)
	result := {
		"value" : statements,
		"is_unique_element" : false
	}
} else = result {
	result := {
		"value" : [statements],
		"is_unique_element" : true
	}
}

is_illegal(Action) = Action {
	is_string(Action)
	Action == illegal_actions[_]
} else = res {
	is_array(Action)
	illegal_actions_list := [a |
    	a := Action[_]
    	illegal_actions[_] == a
	]
	res := concat(", ", illegal_actions_list)
	res != ""
}
