package Cx

CxPolicy[result] {
	fire_rule := input.document[i].resource.azurerm_redis_firewall_rule[name]
	occupied_hosts := getNumHosts(fire_rule.start_ip)
	all_hosts := getNumHosts(fire_rule.end_ip)
	available := abs(all_hosts - occupied_hosts)

	available > 255

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_redis_firewall_rule[%s].start_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_redis_firewall_rule[%s].start_ip' and 'end_ip' should allow no more than 255 hosts", [name]),
		"keyActualValue": sprintf("'azurerm_redis_firewall_rule[%s].start_ip' and 'end_ip' allow %s hosts", [name, available]),
	}
}

getNumHosts(ip) = nhosts {
	nums := split(ip, ".")

	# ip = x.y.z.w
	# hosts = x * 2^24 + y * 2^16 + z * 2^8 + w 
	# 2^24 = 16777216  2^16 = 65536  2^8 = 256
	nhosts := (((to_number(nums[0]) * 16777216) + (to_number(nums[1]) * 65536)) + (to_number(nums[2]) * 256)) + to_number(nums[3])
}
