package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	modules := {"azure.azcollection.azure_rm_sqlserver", "azure_rm_sqlserver"}
	task := ansLib.tasks[id][t]
	sqlserver := task[modules[m]]

	not common_lib.valid_key(sqlserver, "ad_user")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_sqlserver.ad_user should be defined",
		"keyActualValue": "azure_rm_sqlserver.ad_user is undefined",
	}
}
