package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_rediscachefirewallrule", "azure_rm_rediscachefirewallrule"}
	firewall_rule := task[modules[m]]
	ansLib.checkState(firewall_rule)

	firewall_rule.start_ip_address == "0.0.0.0"
	firewall_rule.end_ip_address == "0.0.0.0"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.start_ip_address", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_rediscachefirewallrule start_ip and end_ip should not equal to '0.0.0.0'",
		"keyActualValue": "azure_rm_rediscachefirewallrule start_ip and end_ip are equal to '0.0.0.0'",
	}
}
