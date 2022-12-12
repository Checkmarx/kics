package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]

    resource.transfer_acceleration.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].transfer_acceleration.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'transfer_acceleration.enabled' should be defined and set to true",
		"keyActualValue": "'transfer_acceleration.enabled' is false",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "transfer_acceleration", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	some i
	resource := input.document[i].resource.alicloud_oss_bucket[name]

    not common_lib.valid_key(resource, "transfer_acceleration")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'transfer_acceleration.enabled' should be defined and set to true",
		"keyActualValue": "'transfer_acceleration' is missing",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name], []),
		"remediation": "transfer_acceleration{\n\t\tenabled = true\n\t}",
		"remediationType": "addition",
	}
}
