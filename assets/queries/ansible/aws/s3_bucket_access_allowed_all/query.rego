package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	policy := task["amazon.aws.s3_bucket"].policy
	statement = policy.Statement[_]
	statement.Principal == "*"
	statement.Effect == "Allow"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{amazon.aws.s3_bucket}}.policy.Statement", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{amazon.aws.s3_bucket}}.policy.Statement doesn't make the bucket accessible to all AWS Accounts", [task.name]),
		"keyActualValue": sprintf("name=%s.{{amazon.aws.s3_bucket}}.policy.Statement does make the bucket accessible to all AWS Accounts", [task.name]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
