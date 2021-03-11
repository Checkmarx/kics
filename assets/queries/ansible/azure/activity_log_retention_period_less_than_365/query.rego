package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task.azure_rm_monitorlogprofile
	retentionPolicy := azureMonitor.retention_policy

	not ansLib.isAnsibleTrue(retentionPolicy.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}.retention_policy.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy.enabled is true or yes",
		"keyActualValue": "azure_rm_monitorlogprofile.retention_policy.enabled is false or no",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task.azure_rm_monitorlogprofile
	retentionPolicy := azureMonitor.retention_policy

	ansLib.isAnsibleTrue(retentionPolicy.enabled)
	retentionPolicy.days < 365
	retentionPolicy.days > 0

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}.retention_policy.days", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy.days is greater than 365 days or 0 (indefinitely)",
		"keyActualValue": "azure_rm_monitorlogprofile.retention_policy.days is lesser than 365 days or different than 0 (indefinitely)",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task.azure_rm_monitorlogprofile

	object.get(azureMonitor, "retention_policy", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_monitorlogprofile.retention_policy is defined",
		"keyActualValue": "azure_rm_monitorlogprofile.retention_policy is undefined",
	}
}
