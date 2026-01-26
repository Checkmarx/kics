package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]

	results := no_network_policy_or_disabled(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine,
		"remediation": results.remediation,
		"remediationType": results.remediationType
	}
}

no_network_policy_or_disabled(resource, name) = results {
	not common_lib.valid_key(resource, "network_policy")
	results := {
		"searchKey": sprintf("google_container_cluster[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_container_cluster[%s].network_policy' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_container_cluster[%s].network_policy' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name], []),
		"remediation": "network_policy {\n\t\tenabled = true\n\t}\n",
		"remediationType": "addition"
	 }
} else = results {	# "enabled" is a required field
	resource.network_policy.enabled != true
	results := {
		"searchKey": sprintf("google_container_cluster[%s].network_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_container_cluster[%s].network_policy.enabled' should be set to 'true'", [name]),
		"keyActualValue": sprintf("'google_container_cluster[%s].network_policy.enabled' is set to '%s'", [name, resource.network_policy.enabled]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "network_policy", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement"
	 }
}
