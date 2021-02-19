package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	bucket := task["amazon.aws.s3_bucket"]
	bucketName := task.name

	object.get(bucket, "versioning", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}", [bucketName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.s3_bucket should have versioning set to true",
		"keyActualValue": "amazon.aws.s3_bucket does not have versioning (defaults to false)",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	bucket := task["amazon.aws.s3_bucket"]
	bucketName := task.name
	not ansLib.isAnsibleTrue(bucket.versioning)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.versioning", [bucketName]),
		"issueType": "WrongValue",
		"keyExpectedValue": "amazon.aws.s3_bucket should have versioning set to true",
		"keyActualValue": "amazon.aws.s3_bucket does has versioning set to false",
	}
}
