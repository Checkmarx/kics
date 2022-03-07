package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]

    resource.versioning.status == "Suspended"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].versioning.status", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning.status' is enabled",
		"keyActualValue": "'versioning.status' is suspended",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "versioning", "status"], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]

    not common_lib.valid_key(resource, "versioning")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning.status' is defined and set to enabled",
		"keyActualValue": "'versioning' is missing",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name], []),
	}
}
