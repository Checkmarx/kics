package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

ilegal_actions := ["s3:GetObject", "ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath", "secretsmanager:GetSecretValue","*","s3:*"]

CxPolicy[result] {
	resource := input.document[i].resource["aws_iam_policy"][name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]
	statement.Effect == "Allow"
    statement.Action[i2] == ilegal_actions[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_iam_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'policy.Statement.Action' shouldn't contain '%s'",[statement.Action[i2]]),
		"keyActualValue": sprintf("'policy.Statement.Action' contains '%s'",[statement.Action[i2]]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_policy", name, "policy"], []),
		"searchValue" : sprintf("%s",[statement.Action[i2]]),
	}
}


