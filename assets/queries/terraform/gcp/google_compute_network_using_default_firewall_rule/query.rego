package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	
	computeNetwork := input.document[i].resource.google_compute_network[name]
	
	firewall := input.document[_].resource.google_compute_firewall[_]
	
	tf_lib.matches(firewall.network, name)
	contains(firewall.name, "default")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_network",
		"resourceName": tf_lib.get_resource_name(computeNetwork, name),
		"searchKey": sprintf("google_compute_network[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_network[%s]' should not be using a default firewall rule", [name]),
		"keyActualValue": sprintf("'google_compute_network[%s]' is using a default firewall rule", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_network", name], []),
	}
}
