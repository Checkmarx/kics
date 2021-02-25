package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	s3_bucket := task["amazon.aws.s3_bucket"]

	s3_bucket.encryption == "none"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.encryption", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_s3_bucket.encryption is not 'none'",
		"keyActualValue": "aws_s3_bucket.encryption is 'none'",
	}
}
