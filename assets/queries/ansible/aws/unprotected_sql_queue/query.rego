package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	sqsQueue := task["community.aws.sqs_queue"]
	ansLib.checkState(sqsQueue)

	not sqsQueue.kms_master_key_id

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.sqs_queue}}.kms_master_key_id", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kms_master_key_id' should be set",
		"keyActualValue": "'kms_master_key_id' is undefined",
	}
}
