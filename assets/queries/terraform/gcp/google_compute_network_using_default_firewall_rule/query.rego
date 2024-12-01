package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	computeNetwork := document.resource.google_compute_network[name]

	some firewall in document.resource.google_compute_firewall

	tf_lib.matches(firewall.network, name)
	contains(firewall.name, "default")

	result := {
		"documentId": document.id,
		"resourceType": "google_compute_network",
		"resourceName": tf_lib.get_resource_name(computeNetwork, name),
		"searchKey": sprintf("google_compute_network[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_network[%s]' should not be using a default firewall rule", [name]),
		"keyActualValue": sprintf("'google_compute_network[%s]' is using a default firewall rule", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_network", name], []),
	}
}
