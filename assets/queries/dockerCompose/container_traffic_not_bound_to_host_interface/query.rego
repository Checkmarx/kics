package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	resource := input.document[i]
	service_parameters := resource.services[name]
    ports := service_parameters.ports
    port := ports[v]
    check_ports(port)
	
	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.ports",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Docker compose file to have 'ports' attribute bound to a specific host interface.",
		"keyActualValue": "Docker compose file doesn't have 'ports' attribute bound to a specific host interface",
        "searchLine": common_lib.build_search_line(["services", name, "ports"], []),
	}
}

check_ports(port)
{
	published := port.published
    not contains(published,".")
}else{
	not common_lib.valid_key(port, "published")
	not contains(port,".")
}
