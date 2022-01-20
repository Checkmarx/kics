package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.firewall"
	properties := resource.properties

	common_lib.is_ingress(properties)
	properties.sourceRanges[_] == "0.0.0.0/0"
	ports := isSSHport(properties.allowed[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'dnssecConfig' is defined and not null",
		"keyActualValue": "'dnssecConfig' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

isSSHport(allow) = ports {
	some j
	contains(allow.ports[j], "-")
	port_bounds := split(allow.ports[j], "-")
	low_bound := to_number(port_bounds[0])
	high_bound := to_number(port_bounds[1])
	isInBounds(low_bound, high_bound)
    ports := allow.ports[j]
}

isSSHport(allow) = ports {
	some j
	contains(allow.ports[j], "-") == false
	to_number(allow.ports[j]) == 22
    ports := allow.ports[j]
}

isInBounds(low, high) {
	low <= 22
	high >= 22
}
