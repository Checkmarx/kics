package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document = input.document[i]
	tasks := ansLib.getTasks(document)
	sqsQueuePolicy = tasks[_]
    ansLib.isAnsibleTrue(task["community.aws.sqs_queue"].publicly_accessible)
	sqsQueueBody = sqsQueuePolicy["community.aws.sqs_queue"]
	sqsQueueName = sqsQueuePolicy.name
	object.get(sqsQueueBody, "state", "present") == "present"

	not sqsQueueBody.kms_master_key_id
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.sqs_queue}}.kms_master_key_id", [sqsQueueName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kms_master_key_id' should be set",
		"keyActualValue": "'kms_master_key_id' is undefined",
	}
}
