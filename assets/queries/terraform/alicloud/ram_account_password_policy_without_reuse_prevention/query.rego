package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    not common_lib.valid_key(resource, "password_reuse_prevention")
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'password_reuse_prevention' is defined and equal or lower than 24",
		"keyActualValue": "'password_reuse_prevention' is not defined",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name], []),
		
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.password_reuse_prevention > 24
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].password_reuse_prevention", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'password_reuse_prevention' should be equal or less 24",
		"keyActualValue": "'password_reuse_prevention' is higher than 24",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "password_reuse_prevention"], []),
		
	}
}
