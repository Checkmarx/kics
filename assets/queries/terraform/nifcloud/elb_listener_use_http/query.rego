package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	elb_listener := input.document[i].resource.nifcloud_elb_listener[name]

	elbRef := getElbNetworkInterface(input.document[i].resource, elb_listener.elb_id)
	elbNetworkInterface := getNetworkInterfaces(elbRef.network_interface)[_]
	elbNetworkInterface.network_id == "net-COMMON_GLOBAL"
	elbNetworkInterface.is_vip_network == true

	elb_listener.protocol == "HTTP"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_elb_listener",
		"resourceName": tf_lib.get_resource_name(elb_listener, name),
		"searchKey": sprintf("nifcloud_elb_listener[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_elb_listener[%s]' should switch to HTTPS to benefit from TLS security features.", [name]),
		"keyActualValue": sprintf("'nifcloud_elb_listener[%s]' using HTTP protocol.", [name]),
	}
}

getElbNetworkInterface (resource, interfaceRef) = output {
	interfaceName := split(interfaceRef, ".")[1]
	output := resource.nifcloud_elb[interfaceName]
}

getNetworkInterfaces (networkInterface) = output {
	not is_array(networkInterface) 
	output := [networkInterface]
} else = output {
	output := networkInterface
}