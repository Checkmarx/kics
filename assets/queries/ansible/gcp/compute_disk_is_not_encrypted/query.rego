package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	disk := task["google.cloud.gcp_compute_disk"]
	diskName := task.name

	object.get(disk, "disk_encryption_key", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_disk}}", [diskName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_compute_disk should have a disk_encryption_key value",
		"keyActualValue": "google.cloud.gcp_compute_disk does not have a disk_encryption_key",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
