package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	rule := task.azure_rm_sqlfirewallrule
	ruleName := task.name

	rule.start_ip_address == "0.0.0.0"
	rule.end_ip_address == "0.0.0.0"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_sqlfirewallrule}}", [ruleName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "azure_rm_sqlfirewallrule.start_ip_address is different from '0.0.0.0' and azure_rm_sqlfirewallrule.end_ip_address is different from '0.0.0.0'",
		"keyActualValue": "azure_rm_sqlfirewallrule.start_ip_address is '0.0.0.0' and azure_rm_sqlfirewallrule.end_ip_address is '0.0.0.0'",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	rule := task.azure_rm_sqlfirewallrule
	ruleName := task.name
	startIP_value := calcValue(rule.start_ip_address)
	endIP_value := calcValue(rule.end_ip_address)

	abs(endIP_value - startIP_value) >= 256

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{azure_rm_sqlfirewallrule}}", [ruleName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The difference between the value of 'azure_rm_sqlfirewallrule.end_ip_address' and 'azure_rm_sqlfirewallrule.start_ip_address' is lesser than 256",
		"keyActualValue": "The difference between the value of 'azure_rm_sqlfirewallrule.end_ip_address' and 'azure_rm_sqlfirewallrule.start_ip_address' is greater than or equal to 256",
	}
}

calcValue(val) = result {
	ips := split(val, ".")

	#calculate the value of an ip
	#a.b.c.d
	#a*16777216 + b*65536 + c*256 + d
	result = (((to_number(ips[0]) * 16777216) + (to_number(ips[1]) * 65536)) + (to_number(ips[2]) * 256)) + to_number(ips[3])
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
