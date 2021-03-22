package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_rediscachefirewallrule", "azure_rm_rediscachefirewallrule"}
	firewall_rule := task[modules[m]]
	ansLib.checkState(firewall_rule)

	not privateIP(firewall_rule.start_ip_address)
	not privateIP(firewall_rule.end_ip_address)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.start_ip_address", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_rediscachefirewallrule ip range is private",
		"keyActualValue": "azure_rm_rediscachefirewallrule ip range is public",
	}
}

privateIP(ip) {
	private_ips = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
	net.cidr_contains(private_ips[_], ip)
}
