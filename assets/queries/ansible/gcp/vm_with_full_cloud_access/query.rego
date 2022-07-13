package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_compute_instance", "gcp_compute_instance"}
	taskComputeInstance := task[modules[m]]
	ansLib.checkState(taskComputeInstance)

	service_accounts := taskComputeInstance.service_accounts
	some s
	scopes := service_accounts[s].scopes
	lower(scopes[_]) == "cloud-platform"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.service_accounts", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.service_accounts.scopes should not contain 'cloud-platform'",
		"keyActualValue": "gcp_compute_instance.service_accounts.scopes contains 'cloud-platform'",
	}
}
