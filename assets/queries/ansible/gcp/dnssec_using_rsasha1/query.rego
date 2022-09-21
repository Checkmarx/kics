package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_dns_managed_zone", "gcp_dns_managed_zone"}
	dns := task[modules[m]]
	ansLib.checkState(dns)

	lower(dns.dnssec_config.defaultKeySpecs.algorithm) == "rsasha1"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.dnssec_config.defaultKeySpecs.algorithm", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_dns_managed_zone.dnssec_config.defaultKeySpecs.algorithm should not equal to 'rsasha1'",
		"keyActualValue": "gcp_dns_managed_zone.dnssec_config.defaultKeySpecs.algorithm is equal to 'rsasha1'",
	}
}
