package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_db_instance[name]
	resource.address == "0.0.0.0/0"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_db_instance[%s].address", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'address' should not be set to '0.0.0.0/0'",
		"keyActualValue": "'address' is set to '0.0.0.0/0'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_db_instance", name, "address"], []),
	}
}
