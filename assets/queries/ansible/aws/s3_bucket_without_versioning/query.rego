package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"amazon.aws.s3_bucket", "s3_bucket"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	not common_lib.valid_key(bucket, "versioning")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "s3_bucket should have versioning set to true",
		"keyActualValue": "s3_bucket does not have versioning (defaults to false)",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bucket := task[modules[m]]
	ansLib.checkState(bucket)

	not ansLib.isAnsibleTrue(bucket.versioning)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.versioning", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "s3_bucket should have versioning set to true",
		"keyActualValue": "s3_bucket does has versioning set to false",
	}
}
