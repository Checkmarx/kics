package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.alicloud_ram_account_password_policy[name]
    resource["require_symbols"] == false

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.alicloud_ram_account_password_policy[%s].require_symbols", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.alicloud_ram_account_password_policy[%s].require_symbols is set to 'true'", [name]),
		"keyActualValue": sprintf("resource.alicloud_ram_account_password_policy[%s].require_symbols is configured as 'false'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "require_symbols"], []),
	}
}
