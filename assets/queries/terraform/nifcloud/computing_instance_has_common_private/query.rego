package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	instance := input.document[i].resource.nifcloud_instance[name]
	instance.network_interface[_].network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_instance",
		"resourceName": tf_lib.get_resource_name(instance, name),
		"searchKey": sprintf("nifcloud_instance[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_instance[%s]' should use a private LAN to isolate the private side network from the shared network", [name]),
		"keyActualValue": sprintf("'nifcloud_instance[%s]' has common private network", [name]),
	}
}

CxPolicy[result] {

	instance := input.document[i].resource.nifcloud_instance[name]
	instance.network_interface.network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_instance",
		"resourceName": tf_lib.get_resource_name(instance, name),
		"searchKey": sprintf("nifcloud_instance[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_instance[%s]' should use a private LAN to isolate the private side network from the shared network", [name]),
		"keyActualValue": sprintf("'nifcloud_instance[%s]' has common private network", [name]),
	}
}
