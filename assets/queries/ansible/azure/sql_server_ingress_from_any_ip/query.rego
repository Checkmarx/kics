package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules = {"azure.azcollection.azure_rm_sqlfirewallrule", "azure_rm_sqlfirewallrule"}
	fwRule := task[modules[index]]

	fwRule.start_ip_address == "0.0.0.0"
	isUnsafeEndIpAddress(fwRule.end_ip_address)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.end_ip_address", [task.name, modules[index]]),
		"issueType": "WrongValue",
		"keyExpectedValue": sprintf("%s should not allow all IPs (range from start_ip_address to end_ip_address)", [modules[index]]),
		"keyActualValue": sprintf("%s should allows all IPs", [modules[index]]),
	}
}

isUnsafeEndIpAddress("0.0.0.0") = true

isUnsafeEndIpAddress("255.255.255.255") = true
