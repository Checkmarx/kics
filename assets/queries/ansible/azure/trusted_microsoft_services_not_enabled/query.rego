package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_storageaccount", "azure_rm_storageaccount"}
	storageaccount := task[modules[m]]
	ansLib.checkState(storageaccount)

	lower(storageaccount.network_acls.default_action) == "deny"
	not containsAzureService(storageaccount.network_acls.bypass)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network_acls.bypass", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_storageaccount.network_acls.bypass is not set or contains 'AzureServices'",
		"keyActualValue": "azure_rm_storageaccount.network_acls.bypass does not contain 'AzureServices' ",
	}
}

containsAzureService(bypass) {
	bypass == "\"\""
}

containsAzureService(bypass) {
	values := split(bypass, ",")
	some j
	values[j] == "AzureServices"
}
