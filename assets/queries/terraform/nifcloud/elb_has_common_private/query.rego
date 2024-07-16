package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	elb := input.document[i].resource.nifcloud_elb[name]
	elb.network_interface[_].network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_elb",
		"resourceName": tf_lib.get_resource_name(elb, name),
		"searchKey": sprintf("nifcloud_elb[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_elb[%s]' should use a private LAN to isolate the private side network from the shared network", [name]),
		"keyActualValue": sprintf("'nifcloud_elb[%s]' has common private network", [name]),
	}
}

CxPolicy[result] {

	elb := input.document[i].resource.nifcloud_elb[name]
	elb.network_interface.network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_elb",
		"resourceName": tf_lib.get_resource_name(elb, name),
		"searchKey": sprintf("nifcloud_elb[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_elb[%s]' should use a private LAN to isolate the private side network from the shared network", [name]),
		"keyActualValue": sprintf("'nifcloud_elb[%s]' has common private network", [name]),
	}
}
