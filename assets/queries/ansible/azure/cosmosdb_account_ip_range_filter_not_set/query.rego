package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t].azure_rm_cosmosdbaccount

	not task.ip_range_filter

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_cosmosdbaccount}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'azurerm_cosmosdb_account.ip_range_filter' is defined",
		"keyActualValue": "'azurerm_cosmosdb_account.ip_range_filter' is undefined",
	}
}
