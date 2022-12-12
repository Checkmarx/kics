package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

modules := {"azure.azcollection.azure_rm_sqlfirewallrule", "azure_rm_sqlfirewallrule"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rule := task[modules[m]]
	ansLib.checkState(rule)

	startIP_value := commonLib.calc_IP_value(rule.start_ip_address)
	endIP_value := commonLib.calc_IP_value(rule.end_ip_address)

	abs(endIP_value - startIP_value) >= 256

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The difference between the value of azure_rm_sqlfirewallrule end_ip_address and start_ip_address should be less than 256",
		"keyActualValue": "The difference between the value of azure_rm_sqlfirewallrule end_ip_address and start_ip_address is greater than or equal to 256",
	}
}
