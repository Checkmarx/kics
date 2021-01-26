package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	contains(task["amazon.aws.aws_s3"].permission, "public")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.aws_s3}}.permission", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon_aws_aws_s3.permission is %s", [task["amazon.aws.aws_s3"].permission]),
		"keyActualValue": "amazon_aws_aws_s3.permission allows public access",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
