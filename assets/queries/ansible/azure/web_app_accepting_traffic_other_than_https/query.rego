package Cx

import data.generic.ansible as ansLib

modules := {"azure.azcollection.azure_rm_webapp", "azure_rm_webapp"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	webapp := task[modules[m]]
	ansLib.checkState(webapp)

	not ansLib.isAnsibleTrue(webapp.https_only)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.https_only", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_webapp.https_only is set to true or 'yes'",
		"keyActualValue": sprintf("azure_rm_webapp.https_only value is '%s'", [webapp.https_only]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	webapp := task[modules[m]]
	ansLib.checkState(webapp)

	object.get(webapp, "https_only", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azure_rm_webapp.https_only is defined",
		"keyActualValue": "azure_rm_webapp.https_only is undefined",
	}
}
