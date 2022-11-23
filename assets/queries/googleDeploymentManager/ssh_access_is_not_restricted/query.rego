package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.firewall"
	properties := resource.properties

	common_lib.is_ingress(properties)
	common_lib.is_unrestricted(properties.sourceRanges[_])
	ports := isSSHport(properties.allowed[a])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.allowed[%d].ports=%s", [resource.name, ports]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'allowed[%d].ports' to not include SSH port 22", [a]),
		"keyActualValue": sprintf("'allowed[%d].ports' includes SSH port 22", [a]), 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "allowed", a, "ports"], []),
	}
}

isSSHport(allow) = ports {
	contains(allow.ports[j], "-")
	port_bounds := split(allow.ports[j], "-")
	low_bound := to_number(port_bounds[0])
	high_bound := to_number(port_bounds[1])
	isInBounds(low_bound, high_bound)
  	ports := allow.ports[j]
}

isSSHport(allow) = ports {
	contains(allow.ports[j], "-") == false
	to_number(allow.ports[j]) == 22
  	ports := allow.ports[j]
}

isSSHport(allow) = ports {
	not allow.ports
    isTCPorAll(allow.IPProtocol)
    ports := "0-65535"
}

isTCPorAll(protocol) {
	protocols := {"tcp", "all"}
	lower(protocol) == protocols[_]
}

isInBounds(low, high) {
	low <= 22
	high >= 22
}
