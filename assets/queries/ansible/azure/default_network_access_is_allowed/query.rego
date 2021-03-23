package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}
	storageAccount := task[modules[m]]
	ansLib.checkState(storageAccount)
	default_action := storageAccount.network_acls.default_action

	is_string(default_action)
	lower(default_action) == "allow"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network_acls.default_action", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount.network_acls.default_action is 'Deny'",
		"keyActualValue": "azure_rm_storageaccount.network_acls.default_action is 'Allow'",
	}
}
