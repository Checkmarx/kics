package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.ecs_ecr"].publicly_accessible)
	cloudwatchlogs := task["community.aws.ecs_ecr"]
	pol := cloudwatchlogs.policy.Statement[index].Principal
	re_match("\\*", pol)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Principal' is not equal to '*'",
		"keyActualValue": "'policy.Principal' is equal to '*'",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.ecs_ecr"].publicly_accessible)
	cloudwatchlogs := task["community.aws.ecs_ecr"]
	pol := cloudwatchlogs.policy
	re_match("\"Principal\"\\ *:\\ *\"\\*\"", pol)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.policy", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'policy.Principal' is not equal '*'",
		"keyActualValue": "'policy.Principal' is equal '*'",
	}
}