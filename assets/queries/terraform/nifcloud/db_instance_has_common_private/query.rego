package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {

	dbInstance := input.document[i].resource.nifcloud_db_instance[name]
	dbInstance.network_id == "net-COMMON_PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "nifcloud_db_instance",
		"resourceName": tf_lib.get_resource_name(dbInstance, name),
		"searchKey": sprintf("nifcloud_db_instance[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'nifcloud_db_instance[%s]' should use a private LAN to isolate the private side network from the shared network", [name]),
		"keyActualValue": sprintf("'nifcloud_db_instance[%s]' has common private network", [name]),
	}
}
