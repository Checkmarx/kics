package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	s3 := task["amazon.aws.aws_s3"]
	s3Name := task.name

	s3.permission == "authenticated-read"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.aws_s3}}.permission", [s3Name]),
		"issueType": "WrongValue",
		"keyExpectedValue": "amazon.aws.aws_s3 should not have read access for all authenticated users",
		"keyActualValue": "amazon.aws.aws_s3 has read access for all authenticated users",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
