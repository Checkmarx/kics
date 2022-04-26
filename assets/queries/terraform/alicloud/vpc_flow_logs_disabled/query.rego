package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resources := input.document[i].resource
	alicloudVpc := resources.alicloud_vpc[name_vpc]
	alicloudVpcId := sprintf("${alicloud_vpc.%s.id}", [name_vpc])

	alicloudFlowLogsId := [vpc_id | vpc_id := resources.alicloud_vpc_flow_log[_].resource_id]
	not common_lib.inArray(alicloudFlowLogsId, alicloudVpcId)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_vpc[%s]", [name_vpc]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("alicloud_vpc[%s] is the same as Flow Logs VPC resource id", [name_vpc]),
		"keyActualValue": sprintf("alicloud_vpc[%s] is not the same as Flow Logs VPC resource id", [name_vpc]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_vpc", name_vpc], []),
	}
}

CxPolicy[result] {
	alicloudFlowLogsId := input.document[i].resource.alicloud_vpc_flow_log[name_logs]
	not common_lib.valid_key(alicloudFlowLogsId, "resource_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("alicloud_vpc_flow_log[%s]", [name_logs]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("alicloud_vpc_flow_log[%s].vpc_id is defined and not null", [name_logs]),
		"keyActualValue": sprintf("alicloud_vpc_flow_log[%s].vpc_id is undefined or null", [name_logs]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_vpc_flow_log", name_logs], []),
	}
}
