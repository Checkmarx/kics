package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.tencentcloud_vpc_flow_log_config[name]
	resource.enable == false

	result := {
		"documentId": document.id,
		"resourceType": "tencentcloud_vpc_flow_log_config",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("tencentcloud_vpc_flow_log_config[%s].enable", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("[%s] should have enable set to true", [name]),
		"keyActualValue": sprintf("[%s] has enable set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "tencentcloud_vpc_flow_log_config", name, "enable"], []),
	}
}
