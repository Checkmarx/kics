package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"azure.azcollection.azure_rm_monitorlogprofile", "azure_rm_monitorlogprofile"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task[modules[m]]
	ansLib.checkState(azureMonitor)

	not ansLib.isAnsibleTrue(azureMonitor.retention_policy.enabled)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.retention_policy.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy.enabled should be true or yes",
		"keyActualValue": "azure_rm_monitorlogprofile.retention_policy.enabled is false or no",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task[modules[m]]
	ansLib.checkState(azureMonitor)
	retentionPolicy := azureMonitor.retention_policy

	ansLib.isAnsibleTrue(retentionPolicy.enabled)
	common_lib.between(retentionPolicy.days, 1, 364)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.retention_policy.days", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy.days should be greater than or equal to 365 days or 0 (indefinitely)",
		"keyActualValue": "azure_rm_monitorlogprofile.retention_policy.days is less than 365 days or different than 0 (indefinitely)",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task[modules[m]]
	ansLib.checkState(azureMonitor)

	not common_lib.valid_key(azureMonitor, "retention_policy")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy should be defined",
		"keyActualValue": "azure_rm_monitorlogprofile.retention_policy is undefined",
	}
}
