package Cx

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.max_login_attempts > 5
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].max_login_attempts", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'max_login_attempts' is set to 5 or less",
		"keyActualValue": "'max_login_attempts' is above than 5",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "max_login_attempts"], []),
		
	}
}
