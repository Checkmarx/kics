package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	firewall_rule := task.azure_rm_rediscachefirewallrule

	firewall_rule.start_ip_address == "0.0.0.0"
	firewall_rule.end_ip_address == "0.0.0.0"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'azure_rm_rediscachefirewallrule' start_ip and end_ip are not equal to '0.0.0.0'",
		"keyActualValue": "'azure_rm_rediscachefirewallrule' start_ip and end_ip are equal to '0.0.0.0'",
	}
}
