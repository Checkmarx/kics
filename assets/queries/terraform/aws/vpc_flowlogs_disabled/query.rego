package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource
	awsVpc := resource.aws_vpc[name_vpc]
	awsVpcId := sprintf("${aws_vpc.%s.id}", [name_vpc])

	awsFlowLogsId := [vpc_id | vpc_id := resource.aws_flow_log[_].vpc_id]
	not commonLib.inArray(awsFlowLogsId, awsVpcId)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_vpc[%s]", [name_vpc]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_vpc[%s] is the same as Flow Logs VPC id", [name_vpc]),
		"keyActualValue": sprintf("aws_vpc[%s] is not the same as Flow Logs VPC id", [name_vpc]),
	}
}

CxPolicy[result] {
	awsFlowLogsId := input.document[i].resource.aws_flow_log[name_logs]
	object.get(awsFlowLogsId, "vpc_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_flow_log[%s]", [name_logs]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_flow_log[%s].vpc_id is defined", [name_logs]),
		"keyActualValue": sprintf("aws_flow_log[%s].vpc_id is undefined", [name_logs]),
	}
}
