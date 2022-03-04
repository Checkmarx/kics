package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]

    resource.versioning.status == "Disabled"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].versioning.status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning.status' is enabled",
		"keyActualValue": "'versioning.status' is disabled",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "versioning.status", "enabled"], []),
	}
}
