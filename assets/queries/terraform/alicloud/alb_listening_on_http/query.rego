package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.alicloud_alb_listener[name]
	resource.listener_protocol == "HTTP"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_alb_listener",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("alicloud_alb_listener[%s].listener_protocol", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'alicloud_alb_listener[%s].listener_protocol' should not be 'HTTP'",
		"keyActualValue": "'alicloud_alb_listener[%s].listener_protocol' is 'HTTP'",
		"searchLine": common_lib.build_search_line(["resource", "alicloud_alb_listener", name, "listener_protocol"], []),
		"remediation": json.marshal({
			"before": "HTTP",
			"after": "HTTPS"
		}),
		"remediationType": "replacement"
	}
}
