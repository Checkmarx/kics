package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task.azure_rm_storageaccount.network_acls.default_action == "Deny"
	not containsAzureService(task.azure_rm_storageaccount.network_acls.bypass)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_storageaccount}}.network_acls.bypass", [task.name]),
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
