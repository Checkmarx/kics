package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task.azure_rm_monitorlogprofile
	categories := azureMonitor.categories
	elem := ["write", "action", "delete"][_]

	not containsCategories(categories, elem)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}.categories", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_monitorlogprofile.categories should have all categories, Write, Action and Delete",
		"keyActualValue": "azure_rm_monitorlogprofile.categories does not have all categories, Write, Action and Delete",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	azureMonitor := task.azure_rm_monitorlogprofile

	object.get(azureMonitor, "categories", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_monitorlogprofile}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_monitorlogprofile.categories is defined",
		"keyActualValue": "azure_rm_monitorlogprofile.categories is undefined",
	}
}

containsCategories(categories, elem) {
	lower(categories[_]) == elem
} else = false {
	true
}
