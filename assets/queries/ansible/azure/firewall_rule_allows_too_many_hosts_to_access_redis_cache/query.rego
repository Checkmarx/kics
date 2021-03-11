package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task.azure_rm_rediscachefirewallrule

	occupied_hosts := getHosts(instance.start_ip_address)
	all_hosts := getHosts(instance.end_ip_address)
	available := abs(all_hosts - occupied_hosts)

	available > 255

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address and end_ip_address allows up to 255 hosts", [task.name]),
		"keyActualValue": sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address and end_ip_address allow %s", [task.name, available]),
	}
}

getHosts(ip) = nhosts {
	nums := split(ip, ".")

	# ip = x.y.z.w
	# hosts = x * 2^24 + y * 2^16 + z * 2^8 + w
	# 2^24 = 16777216  2^16 = 65536  2^8 = 256
	nhosts := (((to_number(nums[0]) * 16777216) + (to_number(nums[1]) * 65536)) + (to_number(nums[2]) * 256)) + to_number(nums[3])
}
