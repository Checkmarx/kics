package Cx

import data.generic.common as common_lib
import future.keywords.in

expressionArr := [
	{
		"op": "=",
		"value": "CreateNetworkAcl",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "CreateNetworkAclEntry",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteNetworkAcl",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteNetworkAclEntry",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "ReplaceNetworkAclEntry",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "ReplaceNetworkAclAssociation",
		"name": "$.eventName",
	},
]

check_selector(filter, value, op, name) {
	selector := common_lib.find_selector_by_value(filter, value)
	selector._op == op
	selector._selector == name
}

# { ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }
check_expression_missing(resName, filter, doc) {
	alarm := doc.resource.aws_cloudwatch_metric_alarm[name]
	contains(alarm.metric_name, resName)

	count({x | exp := expressionArr[n]; common_lib.check_selector(filter, exp.value, exp.op, exp.name) == false; x := exp}) == 0
}

CxPolicy[result] {
	some doc in input.document
	resources := doc.resource.aws_cloudwatch_log_metric_filter

	allPatternsCount := count([x | [path, value] := walk(resources); filter := common_lib.json_unmarshal(value.pattern); x = filter])
	count([x | [path, value] := walk(resources); filter := common_lib.json_unmarshal(value.pattern); not check_expression_missing(path[0], filter, doc); x = filter]) == allPatternsCount

	result := {
		"documentId": doc.id,
		"resourceType": "aws_cloudwatch_log_metric_filter",
		"resourceName": "unknown",
		"searchKey": "resource",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern { ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) } and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern { ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) } or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": common_lib.build_search_line([], []),
	}
}
