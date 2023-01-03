package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_cosmosdbaccount", "azure_rm_cosmosdbaccount"}
	cosmosdbaccount := task[modules[m]]
	ansLib.checkState(cosmosdbaccount)

	not common_lib.valid_key(cosmosdbaccount, "tags")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.tags", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_cosmosdbaccount.tags should be defined",
		"keyActualValue": "azure_rm_cosmosdbaccount.tags is undefined",
	}
}
