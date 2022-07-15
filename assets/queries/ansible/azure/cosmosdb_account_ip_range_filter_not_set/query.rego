package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	modules := {"azure.azcollection.azure_rm_cosmosdbaccount", "azure_rm_cosmosdbaccount"}
	task := ansLib.tasks[id][t]
	cosmosdbaccount := task[modules[m]]
	ansLib.checkState(cosmosdbaccount)

	not cosmosdbaccount.ip_range_filter

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'azurerm_cosmosdb_account.ip_range_filter' should be defined",
		"keyActualValue": "'azurerm_cosmosdb_account.ip_range_filter' is undefined",
	}
}
