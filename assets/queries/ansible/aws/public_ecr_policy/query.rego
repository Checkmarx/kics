package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs := task["community.aws.ecs_ecr"]
	pol := cloudwatchlogs.policy.Statement[index].Principal

	re_match("\\*", pol)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Principal' is not equal to '*'",
		"keyActualValue": "'policy.Principal' is equal to '*'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs := task["community.aws.ecs_ecr"]
	pol := cloudwatchlogs.policy

	re_match("\"Principal\"\\ *:\\ *\"\\*\"", pol)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.policy", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'policy.Principal' is not equal '*'",
		"keyActualValue": "'policy.Principal' is equal '*'",
	}
}
