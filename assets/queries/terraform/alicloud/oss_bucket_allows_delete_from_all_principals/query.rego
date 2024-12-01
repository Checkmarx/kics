package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_oss_bucket[name]
	json_policy := resource.policy

	tf_lib.allows_action_from_all_principals(json_policy, "delete")

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_oss_bucket[%s].policy to not accept delete action from all principals", [name]),
		"keyActualValue": sprintf("alicloud_oss_bucket[%s].policy accepts delete action from all principals", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "policy"], []),
	}
}
