package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"azure.azcollection.azure_ad_serviceprincipal", "azure_ad_serviceprincipal"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ad := task[modules[m]]
	ansLib.checkState(ad)

	commonLib.emptyOrNull(ad.ad_user)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.ad_user", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_ad_serviceprincipal.ad_user should be neither empty nor null",
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.ad_user", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_ad_serviceprincipal.ad_user should not be predictable",
		"keyActualValue": "azure_ad_serviceprincipal.ad_user is predictable",
	}
}

check_predictable(name) {
	predictable_names := {"admin", "administrator", "sqladmin", "root", "user", "azure_admin", "azure_administrator", "guest"}
	some i
	predictable_names[i] == lower(name)
}
