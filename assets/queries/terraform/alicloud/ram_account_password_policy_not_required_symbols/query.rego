package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.resource.alicloud_ram_account_password_policy[name]
    resource["require_symbols"] == false

	remediation := {"before": "false", "after": "true"}

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_ram_account_password_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.alicloud_ram_account_password_policy[%s].require_symbols", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.alicloud_ram_account_password_policy[%s].require_symbols should be set to 'true'", [name]),
		"keyActualValue": sprintf("resource.alicloud_ram_account_password_policy[%s].require_symbols is configured as 'false'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_ram_account_password_policy", name, "require_symbols"], []),
		"remediation": json.marshal(remediation),
		"remediationType": "replacement",
	}
}
