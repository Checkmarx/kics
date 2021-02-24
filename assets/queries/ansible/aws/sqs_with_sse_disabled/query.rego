package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	sqs_queue := task["community.aws.sqs_queue"]

	object.get(sqs_queue, "kms_master_key_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.sqs_queue}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kms_master_key_id' is defined",
		"keyActualValue": "'kms_master_key_id' is undefined",
	}
}
