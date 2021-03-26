package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	firewall_rule := input.document[i].resource.azurerm_redis_firewall_rule[name]

	not commonLib.isPrivateIP(firewall_rule.start_ip)
	not commonLib.isPrivateIP(firewall_rule.end_ip)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_redis_firewall_rule[%s].start_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_redis_firewall_rule[%s]' ip range is private", [name]),
		"keyActualValue": sprintf("'azurerm_redis_firewall_rule[%s]' ip range is not private", [name]),
	}
}
