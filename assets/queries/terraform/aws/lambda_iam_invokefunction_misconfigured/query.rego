package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

#CxPolicy for ressource iam policy
CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)

	st := common_lib.get_statement(policy)
	statement := st[_]

	check_lambda_invoke(statement) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_policy[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_policy[%s] is set and not null", [name]),
		"keyActualValue": sprintf("aws_iam_policy[%s] is missing or null", [name]),
	}
}

#CxPolicy for data iam policy document
CxPolicy[result] {
	ressource := input.document[i].data.aws_iam_policy_document[name]

	check_lambda_invoke(ressource.statement[_]) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_policy[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_policy[%s] is set and not null", [name]),
		"keyActualValue": sprintf("aws_iam_policy[%s] is missing or null", [name]),
	}
}

check_lambda_invoke(statement) {
	check_iam_ressource(statement)
	check_iam_action(statement)
} else = false {
	true
}


check_iam_ressource(statement) {
	is_string(statement.Resource)
	regex.match("(^arn:aws:lambda:.*:.*:function:[a-zA-Z0-9_-]+:[*]$)", statement.Resource)
	regex.match("(^arn:aws:lambda:.*:.*:function:[a-zA-Z0-9_-]+$)", statement.Resource)
} else {
	is_array(statement.Resource)
	regex.match("(^arn:aws:lambda:.*:.*:function:[a-zA-Z0-9_-]+:[*]$)", statement.Resource[_])
	regex.match("(^arn:aws:lambda:.*:.*:function:[a-zA-Z0-9_-]+$)", statement.Resource[_])
}

check_iam_action(statement) {
	is_string(statement.Action)
	regex.match("(^lambda:InvokeFunction$)", statement.Action)
} else {
	is_array(statement.Action)
	regex.match("(^lambda:InvokeFunction$)", statement.Action[_])
}
