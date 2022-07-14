package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_rediscache", "azure_rm_rediscache"}
	instance := task[modules[m]]
	ansLib.checkState(instance)

	ansLib.isAnsibleTrue(instance.enable_non_ssl_port)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.enable_non_ssl_port", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_rediscache.enable_non_ssl_port should be set to false or undefined",
		"keyActualValue": "azure_rm_rediscache.enable_non_ssl_port is true",
	}
}
