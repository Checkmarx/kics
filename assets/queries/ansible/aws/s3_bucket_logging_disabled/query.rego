package Cx

import data.generic.ansible as ansLib

modules := {"amazon.aws.s3_bucket", "s3_bucket"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	ansLib.isAnsibleFalse(bucket.debug_botocore_endpoint_logs)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.debug_botocore_endpoint_logs", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "s3_bucket.debug_botocore_endpoint_logs is true",
		"keyActualValue": "s3_bucket.debug_botocore_endpoint_logs is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	object.get(bucket, "debug_botocore_endpoint_logs", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "s3_bucket.debug_botocore_endpoint_logs is defined",
		"keyActualValue": "s3_bucket.debug_botocore_endpoint_logs is undefined",
	}
}
