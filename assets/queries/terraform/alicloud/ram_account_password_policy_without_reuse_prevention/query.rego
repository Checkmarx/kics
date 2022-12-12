package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    not common_lib.valid_key(resource, "password_reuse_prevention")

    result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'password_reuse_prevention' should be defined and equal or lower than 24",
		"keyActualValue": "'password_reuse_prevention' is not defined",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name], []),
		"remediation": "password_reuse_prevention = 24",
        "remediationType": "addition",
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.password_reuse_prevention > 24

    result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].password_reuse_prevention", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'password_reuse_prevention' should be equal or less 24",
		"keyActualValue": "'password_reuse_prevention' is higher than 24",
        "searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "password_reuse_prevention"], []),
		"remediation": json.marshal({
            "before": sprintf("%d", [resource.password_reuse_prevention]),
            "after": "24"
        }),
        "remediationType": "replacement",
	}
}
