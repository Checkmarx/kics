package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

#CxPolicy for resource iam policy
CxPolicy[result] {
	resourceType := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
	resource := input.document[i].resource[resourceType[idx]][name]
	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]
 

	check_iam_action(statement) == true
	not check_iam_resource(statement)

    result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].policy", [resourceType[idx], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("[%s].policy should be misconfigured", [name]),
		"keyActualValue": sprintf("[%s].policy allows access to function (unqualified ARN) and its sub-resources, add another statement with \":*\" to function name", [name])
	}
}

check_iam_resource(statement) {
	is_string(statement.Resource)
	regex.match("(^arn:aws:lambda:.*:.*:function:[a-zA-Z0-9_-]+:[*]$)", statement.Resource)
	regex.match("(^arn:aws:lambda:.*:.*:function:[a-zA-Z0-9_-]+$)", statement.Resource)
} else {
	is_array(statement.Resource)
	regex.match("(^arn:aws:lambda:.*:.*:function:[a-zA-Z0-9_-]+:[*]$)", statement.Resource[_])
	regex.match("(^arn:aws:lambda:.*:.*:function:[a-zA-Z0-9_-]+$)", statement.Resource[_])
} else {
    is_array(statement.resources)
    regex.match("(^aws_lambda_function\\.[^.]\\.arn:[*]$)", statement.resources[_])
    regex.match("(^aws_lambda_function\\.[^.]\\.arn$)", statement.resources[_])
}

check_iam_action(statement) {
	any([regex.match("(^lambda:InvokeFunction$|^lambda:[*]$)", statement.actions[_]), statement.actions[_] == "*"])
} else {
	any([regex.match("(^lambda:InvokeFunction$|^lambda:[*]$)", statement.Actions[_]), statement.Actions[_] == "*"])
} else {
	is_array(statement.Action)
	any([regex.match("(^lambda:InvokeFunction$|^lambda:[*]$)", statement.Action[_]), statement.Action[_] == "*"])
} else {
	is_string(statement.Action)
	any([regex.match("(^lambda:InvokeFunction$|^lambda:[*]$)", statement.Action), statement.Action == "*"])
}
