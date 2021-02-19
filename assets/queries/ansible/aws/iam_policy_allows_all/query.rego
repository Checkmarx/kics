package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway)
	statement := awsApiGateway.policy.Statement[_]
	contains(statement.Resource, "*")
	contains(statement.Effect, "Allow")
	clusterName := task.name
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.policy.Statement.Resource", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Resource not equal '*'",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Resource equal '*'",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway.state)
	policy := json_unmarshal(awsApiGateway.policy)
	statement := policy.Statement[_]
	contains(statement.Resource, "*")
	contains(statement.Effect, "Allow")
	clusterName := task.name
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.Statement.Principal.AWS", [clusterName]),
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

