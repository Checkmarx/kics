package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	resource := input.document[i]
	service_parameters := resource.services[name]
    ports := service_parameters.ports
    port := ports[v]
    check_ports(port)
	
	result := {
    	"debug":sprintf("%s", [port]),
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.ports",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Docker compose file to have 'ports' attribute bound to a host IP address.",
		"keyActualValue": "Docker compose file doesn't have 'ports' attribute bound to a host IP address.",
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
