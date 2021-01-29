package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	modules = {"azure.azcollection.azure_rm_sqlfirewallrule","azure_rm_sqlfirewallrule"}
	fwRule := task[modules[index]]
	fwRuleName := task.name

	fwRule.start_ip_address == "0.0.0.0"
	isUnsafeEndIpAddress(fwRule.end_ip_address)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.end_ip_address", [fwRuleName,modules[index]]),
		"issueType": "WrongValue",
		"keyExpectedValue": sprintf("%s should not allow all IPs (range from start_ip_address to end_ip_address)",[modules[index]]),
		"keyActualValue": sprintf("%s should allows all IPs",[modules[index]]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isUnsafeEndIpAddress("0.0.0.0") = true

isUnsafeEndIpAddress("255.255.255.255") = true
