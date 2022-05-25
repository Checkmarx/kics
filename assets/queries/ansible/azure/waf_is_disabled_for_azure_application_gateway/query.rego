package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_appgateway", "azure_rm_appgateway"}
	appgateway := task[modules[m]]
	ansLib.checkState(appgateway)

	not startswith(appgateway.sku.tier, "waf")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.sku.tier", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_appgateway.sku.tier should be 'waf' or 'waf_v2'",
		"keyActualValue": sprintf("azure_rm_appgateway.sku.tier is %s", [appgateway.sku.tier]),
	}
}
