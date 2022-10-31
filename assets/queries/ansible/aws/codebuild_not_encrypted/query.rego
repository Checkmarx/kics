package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.aws_codebuild", "aws_codebuild"}
	aws_codebuild := task[modules[m]]
	ansLib.checkState(aws_codebuild)

	not common_lib.valid_key(aws_codebuild, "encryption_key")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_codebuild.encryption_key should be set",
		"keyActualValue": "aws_codebuild.encryption_key is undefined",
	}
}
