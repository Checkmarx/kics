package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.sqs_queue", "sqs_queue"}
	sqsQueue := task[modules[m]]
	ansLib.checkState(sqsQueue)

	not sqsQueue.kms_master_key_id

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.kms_master_key_id", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kms_master_key_id' should be set",
		"keyActualValue": "'kms_master_key_id' is undefined",
	}
}
