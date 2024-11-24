package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_oss_bucket[name]

	common_lib.valid_key(resource, "website")

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_oss_bucket",
		"resourceName": tf_lib.get_specific_resource_name(resource, "alicloud_oss_bucket", name),
		"searchKey": sprintf("alicloud_oss_bucket[%s].website", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'website' to not be used.",
		"keyActualValue": "'website' is being used.",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_oss_bucket", name, "website"], []),
	}
}
