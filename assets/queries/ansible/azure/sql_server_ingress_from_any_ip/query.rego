package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"azure.azcollection.azure_rm_sqlfirewallrule", "azure_rm_sqlfirewallrule"}
	fwRule := task[modules[m]]
	ansLib.checkState(fwRule)

	fwRule.start_ip_address == "0.0.0.0"
	isUnsafeEndIpAddress(fwRule.end_ip_address)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.end_ip_address", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_sqlfirewallrule should allow all IPs",
		"keyActualValue": "azure_rm_sqlfirewallrule should not allow all IPs (range from start_ip_address to end_ip_address)",
	}
}

isUnsafeEndIpAddress("255.255.255.255") = true
