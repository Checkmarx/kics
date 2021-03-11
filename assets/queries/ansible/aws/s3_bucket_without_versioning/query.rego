package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task["amazon.aws.s3_bucket"]

	object.get(bucket, "versioning", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.s3_bucket should have versioning set to true",
		"keyActualValue": "amazon.aws.s3_bucket does not have versioning (defaults to false)",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task["amazon.aws.s3_bucket"]

	not ansLib.isAnsibleTrue(bucket.versioning)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.versioning", [task.name]),
		"issueType": "WrongValue",
		"keyExpectedValue": "amazon.aws.s3_bucket should have versioning set to true",
		"keyActualValue": "amazon.aws.s3_bucket does has versioning set to false",
	}
}
