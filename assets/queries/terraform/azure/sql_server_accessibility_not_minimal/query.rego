package Cx

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
	startIP_value := calc_value(resource.start_ip_address)
	endIP_value := calc_value(resource.end_ip_address)
	abs(endIP_value - startIP_value) >= 256

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_sql_firewall_rule[%s].start_ip_address", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_sql_firewall_rule[%s].start_ip_address' The difference between the value of the 'end_ip_address' and of 'start_ip_address' is lesser than 256", [name]),
		"keyActualValue": sprintf("'azurerm_sql_firewall_rule[%s].start_ip_address' The difference between the value of the 'end_ip_address' and of 'start_ip_address' is greater than or equal to 256", [name]),
	}
}

calc_value(val) = result {
	ips := split(val, ".")

	#calculate the value of an ip
	#a.b.c.d
	#a*16777216 + b*65536 + c*256 + d
	result = (((to_number(ips[0]) * 16777216) + (to_number(ips[1]) * 65536)) + (to_number(ips[2]) * 256)) + to_number(ips[3])
}
