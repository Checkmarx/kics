package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	object.get(task["community.aws.aws_codebuild"], "encryption_key", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.aws_codebuild}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.aws_codebuild.encryption_key is set",
		"keyActualValue": "community.aws.aws_codebuild.encryption_key is undefined",
	}
}
