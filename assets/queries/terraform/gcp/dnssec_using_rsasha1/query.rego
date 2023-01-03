package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	dnssec_config := input.document[i].resource.google_dns_managed_zone[name].dnssec_config
	dnssec_config.default_key_specs.algorithm == "rsasha1"
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_dns_managed_zone",
		"resourceName": tf_lib.get_resource_name(dnssec_config, name),
		"searchKey": sprintf("google_dns_managed_zone[%s].dnssec_config.default_key_specs.algorithm", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "dnssec_config.default_key_specs.algorithm shouldn't be 'rsasha1'",
		"keyActualValue": "dnssec_config.default_key_specs.algorithm is 'rsasha1'",
		"searchLine": common_lib.build_search_line(["resource", "google_dns_managed_zone", name],["dnssec_config", "default_key_specs", "algorithm"]),
		"remediation": json.marshal({
			"before": "rsasha1",
			"after": "rsasha256"
		}),
		"remediationType": "replacement",
	}
}
