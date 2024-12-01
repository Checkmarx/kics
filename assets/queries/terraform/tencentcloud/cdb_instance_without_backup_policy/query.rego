package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.tencentcloud_mysql_instance[name]
	not any_backup_policy_matches_instance(name)

	result := {
		"documentId": document.id,
		"resourceType": "tencentcloud_mysql_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_mysql_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("tencentcloud_mysql_instance[%s] should have 'tencentcloud_mysql_backup_policy'", [name]),
		"keyActualValue": sprintf("tencentcloud_mysql_instance[%s] does not have 'tencentcloud_mysql_backup_policy'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_mysql_instance", name], []),
	}
}

any_backup_policy_matches_instance(resource_name) {
	backup_policy := input.document[_].resource.tencentcloud_mysql_backup_policy[_]
	split_name := split(backup_policy.mysql_id, ".")[1]
	split_name == resource_name
}
