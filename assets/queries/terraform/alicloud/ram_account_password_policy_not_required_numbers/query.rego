package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.require_numbers == false 
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].require_numbers", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'require_numbers' is defined and set to true",
		"keyActualValue": "'require_numbers' is false",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "require_numbers"], []),
	}
}
