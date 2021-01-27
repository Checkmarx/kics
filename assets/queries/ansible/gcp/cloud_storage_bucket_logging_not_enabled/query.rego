package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]
	storage_bucket := task["google.cloud.gcp_storage_bucket"]

	object.get(storage_bucket, "logging", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_storage_bucket}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'logging' is defined",
		"keyActualValue": "'logging' is undefined",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
