package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.tencentcloud_instance[name]

	sgs := {"orderly_security_groups", "security_groups"}

	sgInfo := resource[sgs[s]][_]

	contains(lower(sgInfo), "default")

	result := {
		"documentId": doc.id,
		"resourceType": "tencentcloud_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_instance[%s].%s", [name, sgs[s]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("tencentcloud_instance[%s].%s should not be using default security group", [name, s]),
		"keyActualValue": sprintf("tencentcloud_instance[%s].%s is using at least one default security group", [name, s]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_instance", name, sgs[s]], []),
	}
}
