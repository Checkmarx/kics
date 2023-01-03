package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := ["redshift", "community.aws.redshift"]

	ansLib.isAnsibleTrue(task[modules[m]].publicly_accessible)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.publicly_accessible", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "redshift.publicly_accessible should be set to false",
		"keyActualValue": "redshift.publicly_accessible is true",
	}
}
