package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	lb_listener := document.resource.nifcloud_load_balancer_listener[name]
	lb_listener.load_balancer_port == 80

	result := {
		"documentId": document.id,
		"resourceType": "nifcloud_load_balancer_listener",
		"resourceName": tf_lib.get_resource_name(lb_listener, name),
		"searchKey": sprintf("nifcloud_load_balancer_listener[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_load_balancer_listener[%s]' should switch to HTTPS to benefit from TLS security features.", [name]),
		"keyActualValue": sprintf("'nifcloud_load_balancer_listener[%s]' using HTTP port.", [name]),
	}
}
