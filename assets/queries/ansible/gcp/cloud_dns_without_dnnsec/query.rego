package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	object.get(task["google.cloud.gcp_dns_managed_zone"], "dnssec_config", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'dnssec_config' is defined",
		"keyActualValue": "'dnssec_config' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	object.get(task["google.cloud.gcp_dns_managed_zone"].dnssec_config, "state", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}.dnssec_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'dnssec_config.state' is defined",
		"keyActualValue": "'dnssec_config.state' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]

	task["google.cloud.gcp_dns_managed_zone"].dnssec_config.state != "on"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}.dnssec_config.state", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'dnssec_config.state' is equal to 'on'",
		"keyActualValue": "'dnssec_config.state' is not equal to 'on'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
