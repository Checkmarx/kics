package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	firewall := input.document[i].resource.azurerm_sql_firewall_rule[name]
	firewall.start_ip_address = "0.0.0.0"
	checkEndIP(firewall.end_ip_address)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_firewall_rule",
		"resourceName": tf_lib.get_resource_name(firewall, name),
		"searchKey": sprintf("azurerm_sql_firewall_rule[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azurerm_sql_firewall_rule.start_ip_address different from 0.0.0.0 and end_ip_address different from 0.0.0.0 or 255.255.255.255",
		"keyActualValue": "azurerm_sql_firewall_rule.start_ip_address equal to 0.0.0.0 and end_ip_address equal to 0.0.0.0 or 255.255.255.255",
	}
}

checkEndIP("255.255.255.255") = true
