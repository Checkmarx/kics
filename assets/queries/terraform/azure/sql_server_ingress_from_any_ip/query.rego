package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	types := ["azurerm_mssql_firewall_rule","azurerm_sql_firewall_rule", "azurerm_mariadb_firewall_rule", "azurerm_postgresql_firewall_rule", "azurerm_postgresql_flexible_server_firewall_rule", "azurerm_mysql_flexible_server_firewall_rule"]
	firewall := input.document[i].resource[types[i2]][name]
	firewall.start_ip_address = "0.0.0.0"
	checkEndIP(firewall.end_ip_address)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(firewall, name),
		"searchKey": sprintf("%s[%s]", [types[i2],name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.start_ip_address different from 0.0.0.0 and end_ip_address different from 0.0.0.0 or 255.255.255.255",[types[i2]]),
		"keyActualValue": sprintf("%s.start_ip_address equal to 0.0.0.0 and end_ip_address equal to 0.0.0.0 or 255.255.255.255",[types[i2]]),
		"searchLine": common_lib.build_search_line(["resource",types[i2],name],[])
	}
}

checkEndIP("255.255.255.255") = true