package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	nasInstance := input.document[i].resource.nifcloud_nas_instance[name]
	nasInstance.network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_nas_instance",
		"resourceName": tf_lib.get_resource_name(nasInstance, name),
		"searchKey": sprintf("nifcloud_nas_instance[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_nas_instance[%s]' should use a private LAN to isolate the private side network from the shared network", [name]),
		"keyActualValue": sprintf("'nifcloud_nas_instance[%s]' has common private network", [name]),
	}
}
