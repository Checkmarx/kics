package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	awsVpc := resource.aws_vpc[name_vpc]
	awsVpcId := sprintf("${aws_vpc.%s.id}", [name_vpc])

	awsFlowLogsId := [vpc_id | vpc_id := resource.aws_flow_log[_].vpc_id]
	not common_lib.inArray(awsFlowLogsId, awsVpcId)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_vpc",
		"resourceName": name_vpc,
		"searchKey": sprintf("aws_vpc[%s]", [name_vpc]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_vpc[%s] should be the same as Flow Logs VPC id", [name_vpc]),
		"keyActualValue": sprintf("aws_vpc[%s] is not the same as Flow Logs VPC id", [name_vpc]),
		"searchLine": common_lib.build_search_line(["resource", "aws_vpc", name_vpc], []),
	}
}

CxPolicy[result] {
	awsFlowLogsId := input.document[i].resource.aws_flow_log[name_logs]
	not common_lib.valid_key(awsFlowLogsId, "vpc_id")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_flow_log",
		"resourceName": name_logs,
		"searchKey": sprintf("aws_flow_log[%s]", [name_logs]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_flow_log[%s].vpc_id should be defined and not null", [name_logs]),
		"keyActualValue": sprintf("aws_flow_log[%s].vpc_id is undefined or null", [name_logs]),
		"searchLine": common_lib.build_search_line(["resource", "aws_flow_log", name_logs], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_flow_log", "enable_flow_log")

	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("%s.%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.%s should be set to true", [name, keyToCheck]),
		"keyActualValue": sprintf("%s.%s is set to false", [name, keyToCheck]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_flow_log", "enable_flow_log")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.%s should be set to true", [name, keyToCheck]),
		"keyActualValue": sprintf("%s.%s is undefined", [name, keyToCheck]),
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}
