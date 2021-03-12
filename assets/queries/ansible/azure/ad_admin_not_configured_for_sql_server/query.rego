package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	modules := {"azure.azcollection.azure_rm_sqlserver", "azure_rm_sqlserver"}
	task := ansLib.tasks[id][t]
	sqlserver := task[modules[m]]

	object.get(sqlserver, "ad_user", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_sqlserver.ad_user is defined",
		"keyActualValue": "azure_rm_sqlserver.ad_user is undefined",
	}
}
