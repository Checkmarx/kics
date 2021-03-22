package Cx

import data.generic.ansible as ansLib

modules := {"azure.azcollection.azure_rm_aks", "azure_rm_aks"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)

	object.get(aks, "addon", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_aks.addon is set",
		"keyActualValue": "azure_rm_aks.addon is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)

	object.get(aks.addon, "monitoring", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.addon", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_aks.addon.monitoring is set",
		"keyActualValue": "azure_rm_aks.addon.monitoring is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)
	attributes := {"enabled", "log_analytics_workspace_resource_id"}

	object.get(aks.addon.monitoring, attributes[j], "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.addon.monitoring", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azure_rm_aks.addon.monitoring.%s is set", [attributes[j]]),
		"keyActualValue": sprintf("azure_rm_aks.addon.monitoring.%s is undefined", [attributes[j]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	aks := task[modules[m]]
	ansLib.checkState(aks)

	not ansLib.isAnsibleTrue(aks.addon.monitoring.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.addon.monitoring.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_aks.addon.monitoring.enabled is set to 'yes' or 'false'",
		"keyActualValue": "azure_rm_aks.addon.monitoring.enabled is not set to 'yes' or 'false'",
	}
}
