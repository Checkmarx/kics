package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.minimum_password_length < 14
    
    result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].minimum_password_length", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'minimum_password_length' is defined and set to 14 or above",
		"keyActualValue": "'minimum_password_length' is lower than 14",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "minimum_password_length"], []),
		
	}
}


CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    not common_lib.valid_key(resource, "minimum_password_length")
    
    result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'minimum_password_length' is defined and set to 14 or above ",
		"keyActualValue": "'minimum_password_length' is not difined",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name], []),		
	}
}
