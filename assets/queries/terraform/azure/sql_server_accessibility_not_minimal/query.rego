package Cx

import data.generic.common as lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_firewall_rule[name]
	resource.start_ip_address == "0.0.0.0"
	resource.end_ip_address == "0.0.0.0"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_sql_firewall_rule[%s].start_ip_address", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_sql_firewall_rule[%s].start_ip_address' is different from '0.0.0.0'", [name]),
		"keyActualValue": sprintf("'azurerm_sql_firewall_rule[%s].start_ip_address' is equal to '0.0.0.0'", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_firewall_rule[name]
	startIP_value := lib.calc_IP_value(resource.start_ip_address)
	endIP_value := lib.calc_IP_value(resource.end_ip_address)
	abs(endIP_value - startIP_value) >= 256

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_sql_firewall_rule[%s].start_ip_address", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_sql_firewall_rule[%s].start_ip_address' The difference between the value of the 'end_ip_address' and of 'start_ip_address' is lesser than 256", [name]),
		"keyActualValue": sprintf("'azurerm_sql_firewall_rule[%s].start_ip_address' The difference between the value of the 'end_ip_address' and of 'start_ip_address' is greater than or equal to 256", [name]),
	}
}
