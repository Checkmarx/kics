package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_dns_managed_zone", "gcp_dns_managed_zone"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	managed_zone := task[modules[m]]
	ansLib.checkState(managed_zone)

	object.get(managed_zone, "dnssec_config", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_dns_managed_zone.dnssec_config is defined",
		"keyActualValue": "gcp_dns_managed_zone.dnssec_config is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	managed_zone := task[modules[m]]
	ansLib.checkState(managed_zone)

	object.get(managed_zone.dnssec_config, "state", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.dnssec_config", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_dns_managed_zone.dnssec_config.state is defined",
		"keyActualValue": "gcp_dns_managed_zone.dnssec_config.state is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	managed_zone := task[modules[m]]
	ansLib.checkState(managed_zone)

	managed_zone.dnssec_config.state != "on"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.dnssec_config.state", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_dns_managed_zone.dnssec_config.state is equal to 'on'",
		"keyActualValue": "gcp_dns_managed_zone.dnssec_config.state is not equal to 'on'",
	}
}
