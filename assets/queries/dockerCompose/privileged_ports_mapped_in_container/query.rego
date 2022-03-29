package Cx

import data.generic.common as common_lib


CxPolicy[result] {

	resource := input.document[i]
	service_parameters := resource.services[name]
    ports := service_parameters.ports
    port := ports[v]
	is_privileged_port(port)
    not has_cap_drop(service_parameters)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.ports",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Docker compose file to have 'ports' attribute not set to privileged ports (<1024).",
		"keyActualValue": "Docker compose file has 'ports' attribute set to privileged ports (<1024).",
        "searchLine": common_lib.build_search_line(["services", name, "ports"], []),
	}
}

has_cap_drop(service_parameters) {
     service_parameters.cap_drop[_] == "NET_BIND_SERVICE"
}

is_privileged_port(port)
{	#COVERS "HOST" port from short syntax "HOST:CONTAINER" and "CONTAINER" syntax
	both_ports := split(port,":")
    host_port := both_ports[0]
    to_number(host_port) < 1024
}else{#COVERS "CONTAINER" port from short syntax "HOST:CONTAINER"
 	both_ports := split(port,":")
    container_port := both_ports[1]
    to_number(container_port) < 1024
}else{#Covers short syntax part '...:CONTAINER/PROTOCOL'
	both_ports := split(port,":")
    container_port := both_ports[1]
    splitted_cp := split(container_port,"/")
    to_number(splitted_cp[0]) < 1024
}else{#covers "HOST-HOST:CONTAINER-CONTAINER", "IPADDR:HOSTPORT:CONTAINERPORT", "IPADDR:HOST-HOST:CONTAINER-CONTAINER" 
# "IPADDR::CONTAINERPORT" and "HOST-HOST:CONTAINER"
	both_ranges := split(port,":")
    splitted_ports := split(both_ranges[p],"-")
    to_number(splitted_ports[s]) < 1024
}else{#covers "CONTAINER-CONTAINER"
	both_ports := split(port,"-")
    splitted_port := both_ports[p]
    to_number(splitted_port) < 1024
}else{#COVERS LONG SYNTAX PUBLISHED PORT
	port.published < 1024
}else{#COVERS LONG SYNTAX TARGET PORT
	port.target < 1024
}
