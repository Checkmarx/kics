package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.require_lowercase_characters == false
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].require_lowercase_characters", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'require_lowercase_characters' is defined and set to true",
		"keyActualValue": "'require_lowercase_characters' is false",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "require_lowercase_characters"], []),		
	}
}
