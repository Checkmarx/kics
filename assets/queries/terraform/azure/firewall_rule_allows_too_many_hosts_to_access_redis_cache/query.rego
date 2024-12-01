package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	fire_rule := document.resource.azurerm_redis_firewall_rule[name]
	occupied_hosts := commonLib.calc_IP_value(fire_rule.start_ip)
	all_hosts := commonLib.calc_IP_value(fire_rule.end_ip)
	available := abs(all_hosts - occupied_hosts)

	available > 255

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_redis_firewall_rule",
		"resourceName": tf_lib.get_resource_name(fire_rule, name),
		"searchKey": sprintf("azurerm_redis_firewall_rule[%s].start_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_redis_firewall_rule[%s].start_ip' and 'end_ip' should allow no more than 255 hosts", [name]),
		"keyActualValue": sprintf("'azurerm_redis_firewall_rule[%s].start_ip' and 'end_ip' allow %s hosts", [name, available]),
	}
}
