package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	fire_rule := input.document[i].resource.azurerm_redis_firewall_rule[name]
	occupied_hosts := commonLib.calc_IP_value(fire_rule.start_ip)
	all_hosts := commonLib.calc_IP_value(fire_rule.end_ip)
	available := abs(all_hosts - occupied_hosts)

	available > 255

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_redis_firewall_rule[%s].start_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_redis_firewall_rule[%s].start_ip' and 'end_ip' should allow no more than 255 hosts", [name]),
		"keyActualValue": sprintf("'azurerm_redis_firewall_rule[%s].start_ip' and 'end_ip' allow %s hosts", [name, available]),
	}
}
