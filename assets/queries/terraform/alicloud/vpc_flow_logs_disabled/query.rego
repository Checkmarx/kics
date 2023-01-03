package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resources := input.document[i].resource
	alicloudVpc := resources.alicloud_vpc[name_vpc]
	alicloudVpcId := sprintf("${alicloud_vpc.%s.id}", [name_vpc])

	alicloudFlowLogsId := [vpc_id | vpc_id := resources.alicloud_vpc_flow_log[_].resource_id]
	not common_lib.inArray(alicloudFlowLogsId, alicloudVpcId)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "alicloud_vpc",
		"resourceName": name_vpc,
		"searchKey": sprintf("alicloud_vpc[%s]", [name_vpc]),
		"issueType": "IncorrectValue",		
		"keyActualValue": sprintf("alicloud_vpc[%s] is not associated with an 'alicloud_vpc_flow_log'", [name_vpc]),
		"keyExpectedValue": sprintf("alicloud_vpc[%s] is associated with an 'alicloud_vpc_flow_log'", [name_vpc]),
		"searchLine": common_lib.build_search_line(["resource", "alicloud_vpc", name_vpc], []),
	}
}
