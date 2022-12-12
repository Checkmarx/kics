package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.aws_batch_job_definition", "aws_batch_job_definition"}
	batch_job_definition := task[modules[m]]

	ansLib.checkState(batch_job_definition)
	ansLib.isAnsibleTrue(batch_job_definition.privileged)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.privileged", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.privileged should be set to 'false' or not set", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.privileged is 'true'", [task.name, modules[m]]),
	}
}
