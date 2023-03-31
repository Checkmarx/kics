package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	lb := input.document[i].resource.nifcloud_load_balancer[name]
    lb.load_balancer_port == 80

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_load_balancer",
		"resourceName": tf_lib.get_resource_name(lb, name),
		"searchKey": sprintf("nifcloud_load_balancer[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_load_balancer[%s]' should switch to HTTPS to benefit from TLS security features", [name]),
		"keyActualValue": sprintf("'nifcloud_load_balancer[%s]' use HTTP port", [name]),
	}
}

CxPolicy[result] {

	lbListener := input.document[i].resource.nifcloud_load_balancer_listener[name]
    lbListener.load_balancer_port == 80

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_load_balancer_listener",
		"resourceName": tf_lib.get_resource_name(lbListener, name),
		"searchKey": sprintf("nifcloud_load_balancer_listener[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_load_balancer_listener[%s]' should switch to HTTPS to benefit from TLS security features", [name]),
		"keyActualValue": sprintf("'nifcloud_load_balancer_listener[%s]' use HTTP port", [name]),
	}
}
