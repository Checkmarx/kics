package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_cosmosdbaccount", "azure_rm_cosmosdbaccount"}
	cosmosdbaccount := task[modules[m]]
	ansLib.checkState(cosmosdbaccount)

	object.get(cosmosdbaccount, "tags", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.tags", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_cosmosdbaccount.tags is defined",
		"keyActualValue": "azure_rm_cosmosdbaccount.tags is undefined",
	}
}
