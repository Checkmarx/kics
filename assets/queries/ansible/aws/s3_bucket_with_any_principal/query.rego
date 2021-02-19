package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.s3_bucket"].publicly_accessible)
	bucket := task["amazon.aws.s3_bucket"]
	bucketName := task.name

	bucket.policy.Statement[_].Effect == "Allow"
	bucket.policy.Statement[_].Principal == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.policy.Statement", [bucketName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon.aws.s3_bucket[%s] does not allow Action From All Principals", [bucketName]),
		"keyActualValue": sprintf("amazon.aws.s3_bucket[%s] allows Action From All Principals", [bucketName]),
	}
}
