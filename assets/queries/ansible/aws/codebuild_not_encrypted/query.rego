package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["community.aws.aws_codebuild"], "encryption_key", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.aws_codebuild}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.aws_codebuild.encryption_key is set",
		"keyActualValue": "community.aws.aws_codebuild.encryption_key is undefined",
	}
}
