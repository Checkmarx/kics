package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"amazon.aws.s3_bucket", "s3_bucket"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	ansLib.isAnsibleFalse(bucket.debug_botocore_endpoint_logs)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.debug_botocore_endpoint_logs", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "s3_bucket.debug_botocore_endpoint_logs should be true",
		"keyActualValue": "s3_bucket.debug_botocore_endpoint_logs is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	not common_lib.valid_key(bucket, "debug_botocore_endpoint_logs")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "s3_bucket.debug_botocore_endpoint_logs should be defined",
		"keyActualValue": "s3_bucket.debug_botocore_endpoint_logs is undefined",
	}
}
