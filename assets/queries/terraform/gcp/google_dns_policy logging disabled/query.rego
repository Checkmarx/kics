package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	dns := doc.resource["google_dns_policy"][name]

	results := get_results(dns, name)

	result := {
		"documentId": doc.id,
		"resourceType": "google_dns_policy",
		"resourceName": tf_lib.get_resource_name(dns, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
		"remediation": results.remediation,
		"remediationType": results.remediationType,
	}
}

get_results(dns, name) = results {

	not common_lib.valid_key(dns, "enable_logging")

	results := {
		"searchKey": sprintf("google_dns_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_dns_policy[%s].enable_logging' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_dns_policy[%s].enable_logging' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_dns_policy", name], []),
		"remediation": "enable_logging = true",
		"remediationType": "addition",
	}

} else = results {

	dns.enable_logging != true

	results := {
		"searchKey": sprintf("google_dns_policy[%s].enable_logging", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_dns_policy[%s].enable_logging' should be defined and set to true", [name]),
		"keyActualValue": sprintf("'google_dns_policy[%s].enable_logging' is set to %s", [name, dns.enable_logging]),
		"searchLine": common_lib.build_search_line(["resource", "google_dns_policy", name, "enable_logging"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
