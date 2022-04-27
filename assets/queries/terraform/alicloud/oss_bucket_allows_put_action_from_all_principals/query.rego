package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {

	json_policy := input.document[i].resource.alicloud_oss_bucket[name].policy

    terra_lib.allows_action_from_all_principals(json_policy, "put")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].policy",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_oss_bucket[%s].policy to not accept put action from all principals",[name]),
		"keyActualValue": sprintf("alicloud_oss_bucket[%s].policy accepts put action from all principals",[name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "policy"], []),
	}
}
