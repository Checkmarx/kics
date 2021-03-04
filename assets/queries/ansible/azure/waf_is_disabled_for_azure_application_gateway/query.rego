package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	appGateway := task.azure_rm_appgateway
	tier := appGateway.sku.tier

	not startswith(tier, "waf")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_appgateway}}.sku.tier", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_appgateway.sku.tier should be 'waf' or 'waf_v2'",
		"keyActualValue": sprintf("azure_rm_appgateway.sku.tier is %s", [tier]),
	}
}
