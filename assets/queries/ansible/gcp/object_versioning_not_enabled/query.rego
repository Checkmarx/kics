package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	object.get(task["google.cloud.gcp_storage_bucket"], "versioning", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_storage_bucket}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning' is defined",
		"keyActualValue": "'versioning' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	not isAnsibleTrue(task["google.cloud.gcp_storage_bucket"].versioning.enabled)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_storage_bucket}}.versioning.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning.enabled' is true",
		"keyActualValue": "'versioning.enabled' is false",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
