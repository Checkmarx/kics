#not contains '.' (IP) = bad
package Cx

import data.generic.common as common_lib


CxPolicy[result] {

	resource := input.document[i]
	service_parameters := resource.services[name]
    ports := service_parameters.ports
    port := ports[v]
	port_not_IP_bound(port)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.ports",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Docker compose file to have 'ports' attribute not set to privileged ports (<1024).",
		"keyActualValue": "Docker compose file has 'ports' attribute set to privileged ports (<1024).",
        "searchLine": common_lib.build_search_line(["services", name, "ports"], []),
	}
}

port_not_IP_bound(port)
{	
	contains(port,".")
}
