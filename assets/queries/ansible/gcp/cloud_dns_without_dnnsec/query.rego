package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	managed_zone := task["google.cloud.gcp_dns_managed_zone"]

	ansLib.checkState(managed_zone)
	object.get(managed_zone, "dnssec_config", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_dns_managed_zone}}.dnssec_config is defined",
		"keyActualValue": "{{google.cloud.gcp_dns_managed_zone}}.dnssec_config is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	task["google.cloud.gcp_dns_managed_zone"].state == "present"
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
	task := ansLib.getTasks(document)[t]
	task["google.cloud.gcp_dns_managed_zone"].state == "present"
	task["google.cloud.gcp_dns_managed_zone"].dnssec_config.state != "on"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}.dnssec_config.state", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'dnssec_config.state' is equal to 'on'",
		"keyActualValue": "'dnssec_config.state' is not equal to 'on'",
	}
}
