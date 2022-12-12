package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.aws_s3", "aws_s3"}
	aws_s3 := task[modules[m]]
	ansLib.checkState(aws_s3)

	contains(aws_s3.permission, "public")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.permission", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_s3.permission shouldn't allow public access",
		"keyActualValue": "aws_s3.permission allows public access",
	}
}
