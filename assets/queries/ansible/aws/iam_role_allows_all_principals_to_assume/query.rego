package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway)

	policy := json_unmarshal(awsApiGateway.policy)
	statement := policy.Statement[_]
	resource := statement.Principal.AWS
	contains(resource, "arn:aws:iam::")
	contains(resource, ":root")
	not contains(statement.Effect, "Deny")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.Statement.Principal.AWS", [task.name]),
		"issueType": "IncorrectAttribute",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS should not contain ':root",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS contains ':root'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway)

	statement := awsApiGateway.policy.Statement[_]
	resource := statement.Principal[j].AWS
	contains(resource, "arn:aws:iam::")
	contains(resource, ":root")
	not contains(statement.Effect, "Deny")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.Statement.Principal.AWS", [task.name]),
		"issueType": "IncorrectAttribute",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS should not contain ':root",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS contains ':root'",
	}
}

json_unmarshal(s) = result {
	s == null
	result := json.unmarshal("{}")
}

json_unmarshal(s) = result {
	s != null
	result := json.unmarshal(s)
}
