package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.s3_bucket", "s3_bucket"}
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	bucket.policy.Statement[_].Effect == "Allow"
	contains(lower(bucket.policy.Statement[_].Action), "delete")
	bucket.policy.Statement[_].Principal == "*"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy.Statement", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("s3_bucket[%s] does not allow Delete Action From All Principals", [bucket.name]),
		"keyActualValue": sprintf("s3_bucket[%s] allows Delete Action From All Principals", [bucket.name]),
	}
}
