package Cx

CxPolicy [ result ] {
    firewall_rule := input.document[i].resource.azurerm_redis_firewall_rule[name]
    
    firewall_rule.start_ip == "0.0.0.0"
    firewall_rule.end_ip == "0.0.0.0"
    
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("azurerm_redis_firewall_rule[%s].start_ip", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'azurerm_redis_firewall_rule[%s]' start_ip and end_ip are not equal to '0.0.0.0'", [name]),
                "keyActualValue": 	sprintf("'azurerm_redis_firewall_rule[%s]' start_ip and end_ip are equal to '0.0.0.0'", [name]),
              }
}