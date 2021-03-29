package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"azure.azcollection.azure_rm_monitorlogprofile", "azure_rm_monitorlogprofile"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task[modules[m]]
	ansLib.checkState(azureMonitor)
	categories := azureMonitor.categories
	elem := ["write", "action", "delete"][_]

	not commonLib.inArray([c | c := lower(categories[_])], elem)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.categories", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_monitorlogprofile.categories should have all categories, Write, Action and Delete",
		"keyActualValue": "azure_rm_monitorlogprofile.categories does not have all categories, Write, Action and Delete",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task[modules[m]]
	ansLib.checkState(azureMonitor)

	object.get(azureMonitor, "categories", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_monitorlogprofile.categories is defined",
		"keyActualValue": "azure_rm_monitorlogprofile.categories is undefined",
	}
}
