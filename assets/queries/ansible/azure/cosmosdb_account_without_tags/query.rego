package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task.azure_rm_cosmosdbaccount
	not task.azure_rm_cosmosdbaccount.tags

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_cosmosdbaccount}}.tags", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{azure_rm_cosmosdbaccount}}.tags is defined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{azure_rm_cosmosdbaccount}}.tags is undefined", [task.name]),
	}
}
