package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	computeNetwork := document.resource.google_compute_network[name]

	some firewall in input.document[_].resource.google_compute_firewall

	tf_lib.matches(firewall.network, name)
	common_lib.is_ingress(firewall)
	all_ports(firewall.allow)

	result := {
		"documentId": document.id,
		"resourceType": "google_compute_network",
		"resourceName": tf_lib.get_resource_name(computeNetwork, name),
		"searchKey": sprintf("google_compute_network[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_network[%s]' should not be using a firewall rule that allows access to all ports", [name]),
		"keyActualValue": sprintf("'google_compute_network[%s]' is using a firewall rule that allows access to all ports", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_network", name], []),
	}
}

all_ports(allow) {
	is_array(allow)
	allow[_].ports[0] == "0-65535"
} else {
	is_object(allow)
	allow.ports[0] == "0-65535"
}
