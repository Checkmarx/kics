package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	task["amazon.aws.s3_bucket"].encryption == "none"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.s3_bucket}}.encryption", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "amazon.aws.s3_bucket.encryption is not none",
		"keyActualValue": "amazon.aws.s3_bucket.encryption is none",
	}
}