package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
    ansLib.isAnsibleTrue(task["amazon.aws.s3_bucket"].publicly_accessible)
	s3_bucket := task["amazon.aws.s3_bucket"]

	s3_bucket.encryption == "none"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.encryption", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket.encryption is %s", [s3_bucket.encryption]),
		"keyActualValue": "aws_s3_bucket.encryption is none",
	}
}
