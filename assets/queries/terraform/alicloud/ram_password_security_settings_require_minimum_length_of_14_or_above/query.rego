package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.minimum_password_length < 14
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].minimum_password_length", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'minimum_password_length' is defined and set to 14 or above",
		"keyActualValue": "'minimum_password_length' is lower than 14",
		
	}
}


CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    not common_lib.valid_key(resource, "minimum_password_length")
    
    result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'minimum_password_length' is defined and set to 14 or above ",
		"keyActualValue": "'minimum_password_length' is not difined",
		
	}
}
