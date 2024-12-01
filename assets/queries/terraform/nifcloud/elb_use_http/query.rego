package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	elb := doc.resource.nifcloud_elb[name]

	some elbNetworkInterface in elb.network_interface
	elbNetworkInterface.network_id == "net-COMMON_GLOBAL"
	elbNetworkInterface.is_vip_network == true

	elb.protocol == "HTTP"

	result := {
		"documentId": doc.id,
		"resourceType": "nifcloud_elb",
		"resourceName": tf_lib.get_resource_name(elb, name),
		"searchKey": sprintf("nifcloud_elb[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_elb[%s]' should switch to HTTPS to benefit from TLS security features", [name]),
		"keyActualValue": sprintf("'nifcloud_elb[%s]' use HTTP protocol", [name]),
	}
}

CxPolicy[result] {
	some doc in input.document
	elb := doc.resource.nifcloud_elb[name]

	elbNetworkInterface := elb.network_interface
	elbNetworkInterface.network_id == "net-COMMON_GLOBAL"
	elbNetworkInterface.is_vip_network == true

	elb.protocol == "HTTP"

	result := {
		"documentId": doc.id,
		"resourceType": "nifcloud_elb",
		"resourceName": tf_lib.get_resource_name(elb, name),
		"searchKey": sprintf("nifcloud_elb[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_elb[%s]' should switch to HTTPS to benefit from TLS security features.", [name]),
		"keyActualValue": sprintf("'nifcloud_elb[%s]' using HTTP protocol.", [name]),
	}
}
