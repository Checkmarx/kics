package Cx

import data.generic.common as common_lib

CxPolicy[result] {

    input.document[i].resource.alicloud_ram_user_policy_attachment[a]

	result := {
		"documentId": input.document[i].id,
        "searchKey": sprintf("alicloud_ram_user_policy_attachment[%s]",[a]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_ram_user_policy_attachment[%s] should be undefined",[a]),
		"keyActualValue": sprintf("alicloud_ram_user_policy_attachment[%s] is defined",[a]),
        "searchline":common_lib.build_search_line(["resource", "alicloud_ram_user_policy_attachment", a], []),        
	}
}
