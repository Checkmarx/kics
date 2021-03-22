package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_rediscachefirewallrule", "azure_rm_rediscachefirewallrule"}
	instance := task[modules[m]]
	ansLib.checkState(instance)

	occupied_hosts := getHosts(instance.start_ip_address)
	all_hosts := getHosts(instance.end_ip_address)
	available := abs(all_hosts - occupied_hosts)

	available > 255

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.start_ip_address", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_rediscachefirewallrule.start_ip_address and end_ip_address allow up to 255 hosts",
		"keyActualValue": sprintf("azure_rm_rediscachefirewallrule.start_ip_address and end_ip_address allow %d hosts", [available]),
	}
}

getHosts(ip) = nhosts {
	nums := split(ip, ".")

	# ip = x.y.z.w
	# hosts = x * 2^24 + y * 2^16 + z * 2^8 + w
	# 2^24 = 16777216  2^16 = 65536  2^8 = 256
	nhosts := (((to_number(nums[0]) * 16777216) + (to_number(nums[1]) * 65536)) + (to_number(nums[2]) * 256)) + to_number(nums[3])
}
