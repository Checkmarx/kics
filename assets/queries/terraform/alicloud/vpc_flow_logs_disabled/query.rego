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
