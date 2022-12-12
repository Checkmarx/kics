package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"amazon.aws.s3_bucket", "s3_bucket"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3_bucket := task[modules[m]]
	ansLib.checkState(s3_bucket)

	s3_bucket.encryption != "AES256"
	not s3_bucket.encryption_key_id

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encryption", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "s3_bucket.encryption_key_id should be defined",
		"keyActualValue": "s3_bucket.encryption_key_id is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3_bucket := task[modules[m]]
	ansLib.checkState(s3_bucket)

	s3_bucket.encryption != "AES256"
	commonLib.emptyOrNull(s3_bucket.encryption_key_id)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encryption", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "s3_bucket.encryption_key_id should be defined",
		"keyActualValue": "s3_bucket.encryption_key_id is empty or null",
	}
}
