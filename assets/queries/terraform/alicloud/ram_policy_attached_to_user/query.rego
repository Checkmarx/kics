package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_ram_user_policy_attachment[a]

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_ram_user_policy_attachment",
		"resourceName": tf_lib.get_resource_name(resource, a),
		"searchKey": sprintf("alicloud_ram_user_policy_attachment[%s]", [a]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_ram_user_policy_attachment[%s] should be undefined", [a]),
		"keyActualValue": sprintf("alicloud_ram_user_policy_attachment[%s] is defined", [a]),
		"searchline": common_lib.build_search_line(["resource", "alicloud_ram_user_policy_attachment", a], []),
	}
}
