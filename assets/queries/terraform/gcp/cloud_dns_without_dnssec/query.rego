package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_dns_managed_zone[name]

	withoutDNSSec(resource.dnssec_config)

	result := {
		"documentId": document.id,
		"resourceType": "google_dns_managed_zone",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_dns_managed_zone[%s].dnssec_config.state", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'dnssec_config.state' should equal to 'on'",
		"keyActualValue": "'dnssec_config.state' is not equal to 'on'",
		"searchLine": common_lib.build_search_line(["resource", "google_dns_managed_zone", name, "dnssec_config", "state"], []),
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
