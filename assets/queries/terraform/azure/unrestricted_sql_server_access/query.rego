package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_sql_firewall_rule[name]
	startIP_value := common_lib.calc_IP_value(resource.start_ip_address)
	endIP_value := common_lib.calc_IP_value(resource.end_ip_address)
	abs(endIP_value - startIP_value) >= 256

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_sql_firewall_rule",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_sql_firewall_rule[%s].start_ip_address", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_sql_firewall_rule[%s].start_ip_address' The difference between the value of the 'end_ip_address' and of 'start_ip_address' should be less than 256", [name]),
		"keyActualValue": sprintf("'azurerm_sql_firewall_rule[%s].start_ip_address' The difference between the value of the 'end_ip_address' and of 'start_ip_address' is greater than or equal to 256", [name]),
	}
}
