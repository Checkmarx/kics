package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_dns_managed_zone[name]

	withoutDNSSec(resource.dnssec_config)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_dns_managed_zone[%s].dnssec_config.state", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'dnssec_config.state' is equal to 'on'",
		"keyActualValue": "'dnssec_config.state' is not equal to 'on'",
	}
}

withoutDNSSec(dnssec_config) {
	is_array(dnssec_config)
	some i
	dnssec_config[i].state != "on"
}

withoutDNSSec(dnssec_config) {
	is_object(dnssec_config)
	dnssec_config.state != "on"
}
