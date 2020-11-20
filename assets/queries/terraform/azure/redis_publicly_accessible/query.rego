package Cx

CxPolicy [ result ] {
  firewall_rule := input.document[i].resource.azurerm_redis_firewall_rule[name]
  
  not PrivateIP(firewall_rule.start_ip)
  not PrivateIP(firewall_rule.end_ip)
  
  result := {
              "documentId": 		input.document[i].id,
              "searchKey": 	    sprintf("azurerm_redis_firewall_rule[%s].start_ip", [name]),
              "issueType":		"IncorrectValue",
              "keyExpectedValue": sprintf("'azurerm_redis_firewall_rule[%s]' ip range is private", [name]),
              "keyActualValue": 	sprintf("'azurerm_redis_firewall_rule[%s]' ip range is not private", [name]),
            }
}

PrivateIP(ip) {
	private_ips = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
	net.cidr_contains(private_ips[_], ip)
} else = false {
	true
}