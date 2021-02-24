package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storageAccount := task.azure_rm_storageaccount
	default_action := storageAccount.network_acls.default_action

	is_string(default_action)
	lower(default_action) == "allow"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_storageaccount}}.network_acls.default_action", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount.network_acls.default_action is 'Deny'",
		"keyActualValue": "azure_rm_storageaccount.network_acls.default_action is 'Allow'",
	}
}
