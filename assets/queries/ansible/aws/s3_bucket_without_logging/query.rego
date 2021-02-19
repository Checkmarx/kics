package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.s3_bucket"].publicly_accessible)
	bucket := task["amazon.aws.s3_bucket"]
	bucketName := bucket.name
	bucket.debug_botocore_endpoint_logs == false

	result := {
		"documentId": document.id,
		"searchKey": "amazon.aws.s3_bucket.debug_botocore_endpoint_logs",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_s3_bucket.debug_botocore_endpoint_logs is true",
		"keyActualValue": "aws_s3_bucket.debug_botocore_endpoint_logs is false",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.s3_bucket"].publicly_accessible)
	bucket := task["amazon.aws.s3_bucket"]
	bucketName := bucket.name

	object.get(bucket, "debug_botocore_endpoint_logs", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": "amazon.aws.s3_bucket.debug_botocore_endpoint_logs",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_s3_bucket.debug_botocore_endpoint_logs is defined",
		"keyActualValue": "aws_s3_bucket.debug_botocore_endpoint_logs is undefined",
	}
}