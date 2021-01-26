package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]
	firewall_rule := task.azure_rm_rediscachefirewallrule

	firewall_rule.start_ip_address == "0.0.0.0"
	firewall_rule.end_ip_address == "0.0.0.0"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{azure_rm_rediscachefirewallrule}}.start_ip_address", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'azure_rm_rediscachefirewallrule' start_ip and end_ip are not equal to '0.0.0.0'",
		"keyActualValue": "'azure_rm_rediscachefirewallrule' start_ip and end_ip are equal to '0.0.0.0'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
