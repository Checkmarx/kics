package Cx

import data.generic.ansible as ansLib

modules := {"azure.azcollection.azure_ad_serviceprincipal", "azure_ad_serviceprincipal"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ad := task[modules[m]]
	ansLib.checkState(ad)

	ansLib.checkValue(ad.ad_user)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.ad_user", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_ad_serviceprincipal.ad_user is neither empty nor null",
		"keyActualValue": "azure_ad_serviceprincipal.ad_user is empty or null",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ad := task[modules[m]]
	ansLib.checkState(ad)

	is_string(ad.ad_user)
	check_predictable(ad.ad_user)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.ad_user", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_ad_serviceprincipal.ad_user is not predictable",
		"keyActualValue": "azure_ad_serviceprincipal.ad_user is predictable",
	}
}

check_predictable(name) {
	predictable_names := {"admin", "administrator", "sqladmin", "root", "user", "azure_admin", "azure_administrator", "guest"}
	some i
	predictable_names[i] == lower(name)
}
