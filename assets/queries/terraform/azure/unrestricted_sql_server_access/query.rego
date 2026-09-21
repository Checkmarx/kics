package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	types := ["azurerm_mssql_firewall_rule","azurerm_sql_firewall_rule", "azurerm_mariadb_firewall_rule", "azurerm_postgresql_firewall_rule", "azurerm_postgresql_flexible_server_firewall_rule", "azurerm_mysql_flexible_server_firewall_rule"]
	resource := input.document[i].resource[types[i2]][name]
	results := low_abs_difference_or_both_unspecified(resource.start_ip_address ,resource.end_ip_address)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[i2],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].start_ip_address", [types[i2],name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].start_ip_address' %s", [types[i2],name,results.expected_value]),
		"keyActualValue": sprintf("'%s[%s].start_ip_address' %s", [types[i2],name,results.actual_value]),
		"searchLine": common_lib.build_search_line(["resource",types[i2],name,"start_ip_address"],[])
	}
}

low_abs_difference_or_both_unspecified(start_range, end_range) = results {
	# access from Microsoft Azure Infrastructure
	start_range == "0.0.0.0"
	end_range == "0.0.0.0"
	results := {
		"expected_value" : "Firewall rules should not have both 'start_ip_address' and 'end_ip_address' set to '0.0.0.0'.",
		"actual_value" : "Both 'start_ip_address' and 'end_ip_address' are set to '0.0.0.0'"
	}
} else = results{
	startIP_value := common_lib.calc_IP_value(start_range)
	endIP_value := common_lib.calc_IP_value(end_range)

	abs(endIP_value - startIP_value) >= 256
	results := {
		"expected_value" : "The difference between the value of the 'end_ip_address' and 'start_ip_address' should be less than 256",
		"actual_value" : "The difference between the value of the 'end_ip_address' and 'start_ip_address' is greater than or equal to 256"
	}
}
