package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ad := task.azure_ad_serviceprincipal

	ansLib.checkValue(ad.ad_user)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_ad_serviceprincipal}}.ad_user", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_ad_serviceprincipal.ad_user is neither empty nor null",
		"keyActualValue": "azure_ad_serviceprincipal.ad_user is empty or null",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	ad := task.azure_ad_serviceprincipal

	is_string(ad.ad_user)
	check_predictable(ad.ad_user)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_ad_serviceprincipal}}.ad_user", [task.name]),
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
