package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.ecs_ecr"].publicly_accessible)
	stat := task["community.aws.ecs_ecr"].policy.Statement[j]
	stat.Effect == "Allow"
	stat.Principal == "*"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.policy.Statement.Principal='*'", [task.name]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "'Statement.Principal' isn't '*'",
		"keyActualValue": "'Statement.Principal' is '*'",
	}
}