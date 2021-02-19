package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.ecs_taskdefinition"].publicly_accessible)
	task["community.aws.ecs_taskdefinition"].network_mode != "awsvpc"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_taskdefinition}}.network_mode", [task.name]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "'community.aws.ecs_taskdefinition.network_mode' is 'awsvpc'",
		"keyActualValue": sprintf("'community.aws.ecs_taskdefinition.network_mode' is '%s'", [task["community.aws.ecs_taskdefinition"].network_mode]),
	}
}

