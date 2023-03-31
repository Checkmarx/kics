package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	elb := input.document[i].resource.nifcloud_elb[name]

    elb.protocol == "HTTP"
	elbNetworkInterface := elb.network_interface[_]
	elbNetworkInterface.network_id == "net-COMMON_GLOBAL"
	elbNetworkInterface.is_vip_network == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_elb",
		"resourceName": tf_lib.get_resource_name(elb, name),
		"searchKey": sprintf("nifcloud_elb[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_elb[%s]' should switch to HTTPS to benefit from TLS security features", [name]),
		"keyActualValue": sprintf("'nifcloud_elb[%s]' use HTTP protocol", [name]),
	}
}
