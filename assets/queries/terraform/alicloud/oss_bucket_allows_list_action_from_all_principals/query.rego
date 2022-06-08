package Cx

import data.generic.common as common_lib
<<<<<<< HEAD
import data.generic.terraform as terra_lib

CxPolicy[result] {

	json_policy := input.document[i].resource.alicloud_oss_bucket[name].policy

    terra_lib.allows_action_from_all_principals(json_policy, "list")

	result := {
		"documentId": input.document[i].id,
=======
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_oss_bucket[name]
	json_policy := resource.policy

    tf_lib.allows_action_from_all_principals(json_policy, "list")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
>>>>>>> v1.5.10
		"searchKey": sprintf("alicloud_oss_bucket[%s].policy",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_oss_bucket[%s].policy to not accept list action from all principals",[name]),
		"keyActualValue": sprintf("alicloud_oss_bucket[%s].policy accepts list action from all principals",[name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "policy"], []),
	}
}
