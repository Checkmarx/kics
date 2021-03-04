package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway)

	statement := awsApiGateway.policy.Statement[_]
	contains(statement.Resource, "*")
	contains(statement.Effect, "Allow")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.policy.Statement.Resource", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Resource not equal '*'",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Resource equal '*'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway.state)

	policy := json_unmarshal(awsApiGateway.policy)
	statement := policy.Statement[_]
	contains(statement.Resource, "*")
	contains(statement.Effect, "Allow")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.Statement.Principal.AWS", [task.name]),
		"issueType": "IncorrectValue",
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
