package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	stat := task["community.aws.ecs_ecr"].policy.Statement[j]

	stat.Effect == "Allow"
	stat.Principal == "*"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.policy.Statement.Principal='*'", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'Statement.Principal' isn't '*'",
		"keyActualValue": "'Statement.Principal' is '*'",
	}
}
