package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.tencentcloud_instance[name]
	resource.allocate_public_ip == true

	result := {
		"documentId": document.id,
		"resourceType": "tencentcloud_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_instance[%s].allocate_public_ip", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("[%s] 'allocate_public_ip' should be set to false", [name]),
		"keyActualValue": sprintf("[%s] 'allocate_public_ip' is true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_instance", name, "allocate_public_ip"], []),
	}
}
