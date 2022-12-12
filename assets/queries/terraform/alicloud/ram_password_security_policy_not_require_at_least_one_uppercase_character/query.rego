package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_ram_account_password_policy[name]
    resource.require_uppercase_characters == false

    result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_ram_account_password_policy[%s].require_uppercase_characters", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'require_uppercase_characters' should be defined and set to true",
		"keyActualValue": "'require_uppercase_characters' is false",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "require_uppercase_characters"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
