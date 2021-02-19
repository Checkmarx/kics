package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	iam := task["community.aws.iam"]
	iamName := task.name

	is_string(iam.access_key_state)
	lower(iam.access_key_state) == "active"
	iam.iam_type == "user"
	is_string(iam.name)
	contains(lower(iam.name), "root")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam}}", [iamName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam is not active for a root account",
		"keyActualValue": "community.aws.iam is active for a root account",
	}
}
