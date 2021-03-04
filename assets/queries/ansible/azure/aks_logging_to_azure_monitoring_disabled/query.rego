package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task.azure_rm_aks, "addon", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_aks.addon is set",
		"keyActualValue": "azure_rm_aks.addon is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task.azure_rm_aks.addon, "monitoring", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}.addon", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_aks.addon.monitoring is set",
		"keyActualValue": "azure_rm_aks.addon.monitoring is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	attributes := {"enabled", "log_analytics_workspace_resource_id"}

	object.get(task.azure_rm_aks.addon.monitoring, attributes[j], "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}.addon.monitoring", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azure_rm_aks.addon.monitoring.%s is set", [attributes[j]]),
		"keyActualValue": sprintf("azure_rm_aks.addon.monitoring.%s is undefined", [attributes[j]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	not ansLib.isAnsibleTrue(task.azure_rm_aks.addon.monitoring.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_aks}}.addon.monitoring.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_aks.addon.monitoring.enabled is set to 'yes' or 'false'",
		"keyActualValue": "azure_rm_aks.addon.monitoring.enabled is not set to 'yes' or 'false'",
	}
}
