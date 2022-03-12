package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name].lifecycle_rule[_]

    resource["enabled"] == false 

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].lifecycle_rule.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'lifecycle_rule' is set and enabled",
		"keyActualValue": "'lifecycle_rule' is set but disabled",
        "searchline":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "lifecycle_rule", "enabled"], []),
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]

    not common_lib.valid_key(resource, "lifecycle_rule")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'lifecycle_rule' is set and enabled",
		"keyActualValue": "'lifecycle_rule' is not set",
        "searchline":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name], []),
	}
}
