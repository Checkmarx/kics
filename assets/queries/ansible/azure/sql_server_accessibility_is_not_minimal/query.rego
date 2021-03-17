package Cx

import data.generic.ansible as ansLib

modules := {"azure.azcollection.azure_rm_sqlfirewallrule", "azure_rm_sqlfirewallrule"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rule := task[modules[m]]
	ansLib.checkState(rule)

	rule.start_ip_address == "0.0.0.0"
	rule.end_ip_address == "0.0.0.0"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_sqlfirewallrule.start_ip_address is different from '0.0.0.0' and azure_rm_sqlfirewallrule.end_ip_address is different from '0.0.0.0'",
		"keyActualValue": "azure_rm_sqlfirewallrule.start_ip_address is '0.0.0.0' and azure_rm_sqlfirewallrule.end_ip_address is '0.0.0.0'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rule := task[modules[m]]
	ansLib.checkState(rule)

	startIP_value := calcValue(rule.start_ip_address)
	endIP_value := calcValue(rule.end_ip_address)

	abs(endIP_value - startIP_value) >= 256

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The difference between the value of azure_rm_sqlfirewallrule end_ip_address and start_ip_address is lesser than 256",
		"keyActualValue": "The difference between the value of azure_rm_sqlfirewallrule end_ip_address and start_ip_address is greater than or equal to 256",
	}
}

calcValue(val) = result {
	ips := split(val, ".")

	#calculate the value of an ip
	#a.b.c.d
	#a*16777216 + b*65536 + c*256 + d
	result = (((to_number(ips[0]) * 16777216) + (to_number(ips[1]) * 65536)) + (to_number(ips[2]) * 256)) + to_number(ips[3])
}
