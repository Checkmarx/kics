package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {

	json_policy := input.document[i].resource.alicloud_oss_bucket[name].policy

    policy := common_lib.json_unmarshal(json_policy)
	st := common_lib.get_statement(policy)
	statement := st[_]
	statement.Effect == "Allow"
    terra_lib.anyPrincipal(statement)
    common_lib.containsOrInArrayContains(statement.Action, "oss:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_oss_bucket[%s].policy",[name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_oss_bucket[%s].policy to not accept delete action from all principals",[name]),
		"keyActualValue": sprintf("alicloud_oss_bucket[%s].policy accepts delete action from all principals",[name]),
        "searchLine":common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "policy"], []),
	}
}
