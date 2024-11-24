package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_oss_bucket[name]
	sser := resource.server_side_encryption_rule
	not common_lib.valid_key(sser, "kms_master_key_id")

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].server_side_encryption_rule", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("[%s].policy has kms master key id defined", [name]),
		"keyActualValue": sprintf("[%s].policy does not kms master key id defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", "server_side_encryption_rule", name], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_oss_bucket[name]
	not common_lib.valid_key(resource, "server_side_encryption_rule")

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("[%s].policy has server side encryption rule and kms master key id defined", [name]),
		"keyActualValue": sprintf("[%s].policy does not have server side encryption rule and kms master key id defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name], []),
	}
}
