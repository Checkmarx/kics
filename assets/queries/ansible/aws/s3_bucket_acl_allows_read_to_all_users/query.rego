package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.aws_s3", "aws_s3"}
	s3 := task[modules[m]]
	ansLib.checkState(s3)

	startswith(s3.permission, "public-read")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.permission", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_s3 should not have read access for all user groups",
		"keyActualValue": "aws_s3 has read access for all user groups",
	}
}
