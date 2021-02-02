package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	service_accounts := task["google.cloud.gcp_compute_instance"].service_accounts
	some s
	scopes := service_accounts[s].scopes
	lower(scopes[_]) == "cloud-platform"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.service_accounts", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service_accounts.scopes' does not contain 'cloud-platform'",
		"keyActualValue": "'service_accounts.scopes' contains 'cloud-platform'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
