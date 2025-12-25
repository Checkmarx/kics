package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	compute := input.document[i].resource.google_compute_instance[name]
	network_interface := compute.network_interface

	check_interface(network_interface)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_instance",
		"resourceName": tf_lib.get_resource_name(compute, name),
		"searchKey": sprintf("google_compute_instance[%s].network_interface", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_compute_instance[%s].network_interface should not have 'access_config' defined", [name]),
		"keyActualValue": sprintf("google_compute_instance[%s].network_interface has 'access_config' defined", [name]),
		"searchLine": common_lib.build_search_line(["resource","google_compute_instance", name, "network_interface"],[])
	}
}

check_interface(network_interface) {
	is_object(network_interface)
	common_lib.valid_key(network_interface, "access_config")
}

check_interface(network_interface) {
	is_array(network_interface)
	some i
	common_lib.valid_key(network_interface[i], "access_config")
}
