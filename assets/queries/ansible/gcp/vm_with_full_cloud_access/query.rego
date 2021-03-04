package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	taskComputeInstance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(taskComputeInstance)
	service_accounts := taskComputeInstance.service_accounts
	some s
	scopes := service_accounts[s].scopes
	lower(scopes[_]) == "cloud-platform"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_compute_instance}}.service_accounts", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service_accounts.scopes' does not contain 'cloud-platform'",
		"keyActualValue": "'service_accounts.scopes' contains 'cloud-platform'",
	}
}
