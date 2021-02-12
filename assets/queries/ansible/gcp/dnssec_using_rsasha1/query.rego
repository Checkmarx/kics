package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	dns := task["google.cloud.gcp_dns_managed_zone"]

	ansLib.checkState(dns)
	lower(dns.dnssec_config.defaultKeySpecs.algorithm) == "rsasha1"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_dns_managed_zone}}.dnssec_config.defaultKeySpecs.algorithm", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'dnssec_config.defaultKeySpecs.algorithm' is not equal to 'rsasha1'",
		"keyActualValue": "'dnssec_config.defaultKeySpecs.algorithm' is equal to 'rsasha1'",
	}
}
