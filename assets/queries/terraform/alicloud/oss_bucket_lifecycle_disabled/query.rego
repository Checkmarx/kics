package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name].lifecycle_rule[_]

    resource["enabled"] == false 

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].lifecycle_rule.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'lifecycle_rule' should be set and enabled",
		"keyActualValue": "'lifecycle_rule' is set but disabled",
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "lifecycle_rule", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]

    not common_lib.valid_key(resource, "lifecycle_rule")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'lifecycle_rule' should be set and enabled",
		"keyActualValue": "'lifecycle_rule' is not set",
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name], []),
	}
}
