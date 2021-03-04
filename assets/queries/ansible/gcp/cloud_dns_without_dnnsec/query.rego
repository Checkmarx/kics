package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	managed_zone := task["google.cloud.gcp_dns_managed_zone"]

	ansLib.checkState(managed_zone)
	object.get(managed_zone, "dnssec_config", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_dns_managed_zone}}.dnssec_config is defined",
		"keyActualValue": "{{google.cloud.gcp_dns_managed_zone}}.dnssec_config is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	managed_zone := task["google.cloud.gcp_dns_managed_zone"]

	ansLib.checkState(managed_zone)
	object.get(managed_zone.dnssec_config, "state", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}.dnssec_config", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_dns_managed_zone}}.dnssec_config.state is defined",
		"keyActualValue": "{{google.cloud.gcp_dns_managed_zone}}.dnssec_config.state is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	managed_zone := task["google.cloud.gcp_dns_managed_zone"]

	ansLib.checkState(managed_zone)
	managed_zone.dnssec_config.state != "on"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}.dnssec_config.state", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_dns_managed_zone}}.dnssec_config.state is equal to 'on'",
		"keyActualValue": "{{google.cloud.gcp_dns_managed_zone}}.dnssec_config.state is not equal to 'on'",
	}
}
