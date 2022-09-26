package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_rediscachefirewallrule", "azure_rm_rediscachefirewallrule"}
	instance := task[modules[m]]
	ansLib.checkState(instance)

	occupied_hosts := commonLib.calc_IP_value(instance.start_ip_address)
	all_hosts := commonLib.calc_IP_value(instance.end_ip_address)
	available := abs(all_hosts - occupied_hosts)

	available > 255

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.start_ip_address", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_rediscachefirewallrule.start_ip_address and end_ip_address should allow up to 255 hosts",
		"keyActualValue": sprintf("azure_rm_rediscachefirewallrule.start_ip_address and end_ip_address allow %d hosts", [available]),
	}
}
