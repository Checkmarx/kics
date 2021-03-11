package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task["amazon.aws.s3_bucket"]

	ansLib.isAnsibleFalse(bucket.debug_botocore_endpoint_logs)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.debug_botocore_endpoint_logs", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_s3_bucket.debug_botocore_endpoint_logs is true",
		"keyActualValue": "aws_s3_bucket.debug_botocore_endpoint_logs is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task["amazon.aws.s3_bucket"]

	object.get(bucket, "debug_botocore_endpoint_logs", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_s3_bucket.debug_botocore_endpoint_logs is defined",
		"keyActualValue": "aws_s3_bucket.debug_botocore_endpoint_logs is undefined",
	}
}
