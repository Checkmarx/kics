package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.tencentcloud_instance[name]

	sgs := {"orderly_security_groups", "security_groups"}

	some sgInfo in resource[sgs[s]]

	contains(lower(sgInfo), "default")

	result := {
		"documentId": document.id,
		"resourceType": "tencentcloud_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_instance[%s].%s", [name, sgs[s]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_instance[%s].%s should not contain 'default'", [name, s]),
		"keyActualValue": sprintf("tencentcloud_instance[%s].%s contains 'default'", [name, s]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_instance", name, sgs[s]], []),
	}
}
