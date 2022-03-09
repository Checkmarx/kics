package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    not common_lib.valid_key(resource, "max_password_age")
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'max_password_age' should be higher than 0 and lower than 91",
		"keyActualValue": "'max_password_age' is not defined",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name], []),
		
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.max_password_age > 90
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].max_password_age", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'max_password_age' should be higher than 0 and lower than 91",
		"keyActualValue": "'max_password_age' is higher than 90",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "max_password_age"], []),
		
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.max_password_age == 0
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].max_password_age", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'max_password_age' should be higher than 0 and lower than 91",
		"keyActualValue": "'max_password_age' is equal to 0",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "max_password_age"], []),
		
	}
}
