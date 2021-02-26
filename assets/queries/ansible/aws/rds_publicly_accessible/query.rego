package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	ansLib.isAnsibleTrue(task["community.aws.rds_instance"].publicly_accessible)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.rds_instance}}.publicly_accessible", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module's parameter community.aws.rds_instance.publicly_accessible should be false in task: '%s'", [task.name]),
		"keyActualValue": sprintf("module's parameter community.aws.rds_instance.publicly_accessible is true in task: '%s'", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	ansLib.isAnsibleTrue(task["community.aws.rds"].publicly_accessible)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.rds}}.publicly_accessible", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module's parameter community.aws.rds.publicly_accessible should be false in task: '%s'", [task.name]),
		"keyActualValue": sprintf("module's parameter community.aws.rds.publicly_accessible is true in task: '%s'", [task.name]),
	}
}
