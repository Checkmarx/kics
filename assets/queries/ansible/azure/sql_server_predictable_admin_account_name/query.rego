package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	server := task.azure_rm_sqlserver

	ansLib.checkValue(server.admin_username)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_sqlserver}}.admin_username", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_sqlserver.admin_username is not empty",
		"keyActualValue": "azure_rm_sqlserver.admin_username is empty",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	server := task.azure_rm_sqlserver

	is_string(server.admin_username)
	check_predictable(server.admin_username)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_sqlserver}}.admin_username", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_sqlserver.admin_username is not predictable",
		"keyActualValue": "azure_rm_sqlserver.admin_username is predictable",
	}
}

check_predictable(username) {
	predictable_names := {"admin", "administrator", "root", "user", "azure_admin", "azure_administrator", "guest"}
	some i
	lower(username) == predictable_names[i]
}
