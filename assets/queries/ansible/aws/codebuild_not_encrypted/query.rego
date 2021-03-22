package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.aws_codebuild", "aws_codebuild"}
	aws_codebuild := task[modules[m]]
	ansLib.checkState(aws_codebuild)

	object.get(aws_codebuild, "encryption_key", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_codebuild.encryption_key is set",
		"keyActualValue": "aws_codebuild.encryption_key is undefined",
	}
}
