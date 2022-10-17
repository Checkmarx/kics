package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    not common_lib.valid_key(resource, "max_password_age")
    
    result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'max_password_age' should be higher than 0 and lower than 91",
		"keyActualValue": "'max_password_age' is not defined",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name], []),
        "remediation": "max_password_age = 12",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.max_password_age > 90
    
    result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].max_password_age", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'max_password_age' should be higher than 0 and lower than 91",
		"keyActualValue": "'max_password_age' is higher than 90",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "max_password_age"], []),
		"remediation": json.marshal({
            "before": sprintf("%d", [resource.max_password_age]),
            "after": "12"
        }),
        "remediationType": "replacement",
		
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.max_password_age == 0
    
    result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].max_password_age", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'max_password_age' should be higher than 0 and lower than 91",
		"keyActualValue": "'max_password_age' is equal to 0",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "max_password_age"], []),
		"remediation": json.marshal({
            "before": sprintf("%d", [resource.max_password_age]),
            "after": "12"
        }),
        "remediationType": "replacement",		
	}
}
