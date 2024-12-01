package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.tencentcloud_clb_instance[name]
	not common_lib.valid_key(resource, "log_set_id")
	not common_lib.valid_key(resource, "log_topic_id")

	result := {
		"documentId": document.id,
		"resourceType": "tencentcloud_clb_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_clb_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("tencentcloud_clb_instance[%s] should set 'log_set_id' and 'log_topic_id'", [name]),
		"keyActualValue": sprintf("tencentcloud_clb_instance[%s] not set 'log_set_id' and 'log_topic_id'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_clb_instance", name], []),
	}
}
