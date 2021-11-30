package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	
	computeNetwork := input.document[i].resource.google_compute_network[name]
	
	firewall := input.document[_].resource.google_compute_firewall[_]
	
	terra_lib.matches(firewall.network, name)
	contains(firewall.name, "default")
	
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_network[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_network[%s]' is not using a default firewall rule", [name]),
		"keyActualValue": sprintf("'google_compute_network[%s]' is using a default firewall rule", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_compute_network", name], []),
	}
}
