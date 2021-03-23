package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.s3_bucket", "s3_bucket"}
	s3_bucket := task[modules[m]]
	ansLib.checkState(s3_bucket)

	s3_bucket.encryption == "none"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encryption", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "s3_bucket.encryption is not 'none'",
		"keyActualValue": "s3_bucket.encryption is 'none'",
	}
}
