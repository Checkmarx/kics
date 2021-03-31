package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"azure.azcollection.azure_rm_monitorlogprofile", "azure_rm_monitorlogprofile"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task[modules[m]]
	ansLib.checkState(azureMonitor)

	not ansLib.isAnsibleTrue(azureMonitor.retention_policy.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.retention_policy.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy.enabled is true or yes",
		"keyActualValue": "azure_rm_monitorlogprofile.retention_policy.enabled is false or no",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task[modules[m]]
	ansLib.checkState(azureMonitor)
	retentionPolicy := azureMonitor.retention_policy

	ansLib.isAnsibleTrue(retentionPolicy.enabled)
	commonLib.between(retentionPolicy.days, 1, 364)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.retention_policy.days", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy.days is greater than or equal to 365 days or 0 (indefinitely)",
		"keyActualValue": "azure_rm_monitorlogprofile.retention_policy.days is lesser than 365 days or different than 0 (indefinitely)",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task[modules[m]]
	ansLib.checkState(azureMonitor)

	object.get(azureMonitor, "retention_policy", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy is defined",
		"keyActualValue": "azure_rm_monitorlogprofile.retention_policy is undefined",
	}
}
