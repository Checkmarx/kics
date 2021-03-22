package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"community.aws.iam_managed_policy", "iam_managed_policy"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task[modules[m]]
	ansLib.checkState(awsApiGateway)

	policy := commonLib.json_unmarshal(awsApiGateway.policy)
	statement := policy.Statement[_]
	resource := statement.Principal.AWS
	contains(resource, "arn:aws:iam::")
	contains(resource, ":root")
	not contains(statement.Effect, "Deny")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.Statement.Principal.AWS", [task.name, modules[m]]),
		"issueType": "IncorrectAttribute",
		"keyExpectedValue": "iam_managed_policy.policy.Statement.Principal.AWS should not contain ':root",
		"keyActualValue": "iam_managed_policy.policy.Statement.Principal.AWS contains ':root'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task[modules[m]]
	ansLib.checkState(awsApiGateway)

	statement := awsApiGateway.policy.Statement[_]
	resource := statement.Principal[j].AWS
	contains(resource, "arn:aws:iam::")
	contains(resource, ":root")
	not contains(statement.Effect, "Deny")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.Statement.Principal.AWS", [task.name, modules[m]]),
		"issueType": "IncorrectAttribute",
		"keyExpectedValue": "iam_managed_policy.policy.Statement.Principal.AWS should not contain ':root",
		"keyActualValue": "iam_managed_policy.policy.Statement.Principal.AWS contains ':root'",
	}
}
