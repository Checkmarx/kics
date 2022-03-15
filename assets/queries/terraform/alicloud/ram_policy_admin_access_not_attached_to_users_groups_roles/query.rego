package Cx

import data.generic.common as common_lib

CxPolicy[result] {

    ram_policy := input.document[i].resource.alicloud_ram_policy[name]
    
    is_admin_policy(ram_policy.document)
    
    policy_attachment_possibilities := {"alicloud_ram_user_policy_attachment", "alicloud_ram_group_policy_attachment", "alicloud_ram_role_policy_attachment"}
    attachment := policy_attachment_possibilities[pap]
    attach := input.document[_].resource[attachment][n]
    
    target_policy_name := split(attach.policy_name, ".")[1]
    
    target_policy_name == name 
    
    
	result := {
		"documentId": input.document[i].id,
		"searchline":common_lib.build_search_line(["resource", attachment, n ,"policy_name"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_ram_policy[%s] does not give admin access to any user, group or role",[name]),
		"keyActualValue": sprintf("alicloud_ram_policy[%s] is attached to a user, group or role and gives admin access",[name]),
        "searchKey": sprintf("%s[%s].policy_name",[attachment, n]),
	}
}


is_admin_policy(ram_policy)
{
	u_policy := common_lib.json_unmarshal(ram_policy)
	statement := common_lib.get_statement(u_policy)
    st:=statement[_]
	st.Effect == "Allow"
    common_lib.containsOrInArrayContains(st.Resource, "*")
    common_lib.containsOrInArrayContains(st.Action, "*")
}
