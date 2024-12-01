package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some resource in input.document
	service_parameters := resource.services[name]
	ports := service_parameters.ports
	port := ports[v]
	is_privileged_port(port)
	not has_cap_drop(service_parameters)

	result := {
		"documentId": sprintf("%s", [resource.id]),
		"searchKey": sprintf("services.%s.ports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Docker compose file to have 'ports' attribute not set to privileged ports (<1024).",
		"keyActualValue": "Docker compose file has 'ports' attribute set to privileged ports (<1024).",
		"searchLine": common_lib.build_search_line(["services", name, "ports"], []),
	}
}

has_cap_drop(service_parameters) {
	"NET_BIND_SERVICE" in service_parameters.cap_drop
}

is_privileged_port(port) {
	# COVERS "HOST" port from short syntax "HOST:CONTAINER" and "CONTAINER" syntax
	both_ports := split(port, ":")
	host_port := both_ports[0]
	to_number(host_port) < 1024
} # COVERS "CONTAINER" port from short syntax "HOST:CONTAINER"

else {
	both_ports := split(port, ":")
	container_port := both_ports[1]
	to_number(container_port) < 1024
} # Covers short syntax part '...:CONTAINER/PROTOCOL'

else {
	both_ports := split(port, ":")
	container_port := both_ports[1]
	splitted_cp := split(container_port, "/")
	to_number(splitted_cp[0]) < 1024
} # covers "HOST-HOST:CONTAINER-CONTAINER", "IPADDR:HOSTPORT:CONTAINERPORT", "IPADDR:HOST-HOST:CONTAINER-CONTAINER"

else {
	# "IPADDR::CONTAINERPORT" and "HOST-HOST:CONTAINER"
	both_ranges := split(port, ":")
	splitted_ports := split(both_ranges[p], "-")
	to_number(splitted_ports[s]) < 1024
} # covers "CONTAINER-CONTAINER"

else {
	both_ports := split(port, "-")
	splitted_port := both_ports[p]
	to_number(splitted_port) < 1024
} # COVERS LONG SYNTAX PUBLISHED PORT

else {
	port.published < 1024
} # COVERS LONG SYNTAX TARGET PORT

else {
	port.target < 1024
}
