package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]
    
    resource.transfer_acceleration.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].transfer_acceleration.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'transfer_acceleration.enabled' is defined and set to true",
		"keyActualValue": "'transfer_acceleration.enabled' is false",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "transfer_acceleration", "enabled"], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]
    
    not common_lib.valid_key(resource, "transfer_acceleration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'transfer_acceleration.enabled' is defined and set to true",
		"keyActualValue": "'transfer_acceleration' is missing",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name], []),
	}
}
