package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	router := document.resource.nifcloud_router[name]
	router.network_interface[_].network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": document.id,
		"resourceType": "nifcloud_router",
		"resourceName": tf_lib.get_resource_name(router, name),
		"searchKey": sprintf("nifcloud_router[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_router[%s]' should use a private LAN to isolate the private side network from the shared network.", [name]),
		"keyActualValue": sprintf("'nifcloud_router[%s]' has common private network.", [name]),
	}
}

CxPolicy[result] {
	some document in input.document
	router := document.resource.nifcloud_router[name]
	router.network_interface.network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": document.id,
		"resourceType": "nifcloud_router",
		"resourceName": tf_lib.get_resource_name(router, name),
		"searchKey": sprintf("nifcloud_router[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_router[%s]' should use a private LAN to isolate the private side network from the shared network.", [name]),
		"keyActualValue": sprintf("'nifcloud_router[%s]' has common private network.", [name]),
	}
}
