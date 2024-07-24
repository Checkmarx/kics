package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	router := input.document[i].resource.nifcloud_router[name]
	router.network_interface[_].network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_router",
		"resourceName": tf_lib.get_resource_name(router, name),
		"searchKey": sprintf("nifcloud_router[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_router[%s]' should use a private LAN to isolate the private side network from the shared network.", [name]),
		"keyActualValue": sprintf("'nifcloud_router[%s]' has common private network.", [name]),
	}
}

CxPolicy[result] {

	router := input.document[i].resource.nifcloud_router[name]
	router.network_interface.network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_router",
		"resourceName": tf_lib.get_resource_name(router, name),
		"searchKey": sprintf("nifcloud_router[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_router[%s]' should use a private LAN to isolate the private side network from the shared network.", [name]),
		"keyActualValue": sprintf("'nifcloud_router[%s]' has common private network.", [name]),
	}
}
