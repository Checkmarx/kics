package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_rediscachefirewallrule", "azure_rm_rediscachefirewallrule"}
	firewall_rule := task[modules[m]]
	ansLib.checkState(firewall_rule)

	not commonLib.isPrivateIP(firewall_rule.start_ip_address)
	not commonLib.isPrivateIP(firewall_rule.end_ip_address)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.start_ip_address", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_rediscachefirewallrule ip range should be private",
		"keyActualValue": "azure_rm_rediscachefirewallrule ip range is public",
	}
}
