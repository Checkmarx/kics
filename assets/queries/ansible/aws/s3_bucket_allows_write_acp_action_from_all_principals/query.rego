package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	bucket := task["amazon.aws.s3_bucket"]
	taskName := task.name
	bucketName := bucket.name

	bucket.policy.Statement[_].Effect == "Allow"
	contains(lower(bucket.policy.Statement[_].Action), "write")
	contains(lower(bucket.policy.Statement[_].Action), "acp")
	bucket.policy.Statement[_].Principal == "*"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{amazon.aws.s3_bucket}}.policy.Statement", [taskName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("amazon.aws.s3_bucket[%s] does not allow WriteACP Action From All Principals", [bucketName]),
		"keyActualValue": sprintf("amazon.aws.s3_bucket[%s] allows WriteACP Action From All Principals", [bucketName]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
