package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"azure.azcollection.azure_rm_sqlserver", "azure_rm_sqlserver"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	server := task[modules[m]]
	ansLib.checkState(server)

	commonLib.emptyOrNull(server.admin_username)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.admin_username", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_sqlserver.admin_username should not be empty",
		"keyActualValue": "azure_rm_sqlserver.admin_username is empty",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	server := task[modules[m]]
	ansLib.checkState(server)

	is_string(server.admin_username)
	check_predictable(server.admin_username)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.admin_username", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_sqlserver.admin_username should not be predictable",
		"keyActualValue": "azure_rm_sqlserver.admin_username is predictable",
	}
}

check_predictable(username) {
	predictable_names := {"admin", "administrator", "root", "user", "azure_admin", "azure_administrator", "guest"}
	some i
	lower(username) == predictable_names[i]
}
