package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	firewall_rule := task.azure_rm_rediscachefirewallrule

	not privateIP(firewall_rule.start_ip_address)
	not privateIP(firewall_rule.end_ip_address)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'azure_rm_rediscachefirewallrule' ip range is private",
		"keyActualValue": "'azure_rm_rediscachefirewallrule' ip range is public",
	}
}

privateIP(ip) {
	private_ips = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
	net.cidr_contains(private_ips[_], ip)
}
