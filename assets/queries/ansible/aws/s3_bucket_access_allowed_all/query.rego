package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.s3_bucket", "s3_bucket"}
	s3_bucket := task[modules[m]]
	ansLib.checkState(s3_bucket)
	statement := s3_bucket.policy.Statement[_]

	statement.Principal == "*"
	statement.Effect == "Allow"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy.Statement", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "s3_bucket.policy.Statement doesn't make the bucket accessible to all AWS Accounts",
		"keyActualValue": "s3_bucket.policy.Statement does make the bucket accessible to all AWS Accounts",
	}
}
