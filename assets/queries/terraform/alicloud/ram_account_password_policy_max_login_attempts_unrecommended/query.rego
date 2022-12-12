package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.max_login_attempts > 5
    
    result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].max_login_attempts", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'max_login_attempts' should be set to 5 or less",
		"keyActualValue": "'max_login_attempts' is above than 5",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "max_login_attempts"], []),
		"remediation": json.marshal({
            "before": sprintf("%d", [resource.max_login_attempts]),
            "after": "5"
        }),
        "remediationType": "replacement",
	}
}
