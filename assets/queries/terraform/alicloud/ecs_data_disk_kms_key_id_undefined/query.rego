package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.alicloud_disk[name]
	not common_lib.valid_key(resource, "kms_key_id")

	result := {
		"documentId": document.id,
		"resourceType": "alicloud_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_disk[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("[%s] has kms key id defined", [name]),
		"keyActualValue": sprintf("[%s] does not have kms key id defined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_disk", name], []),
	}
}
