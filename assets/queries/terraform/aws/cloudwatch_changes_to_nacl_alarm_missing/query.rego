package Cx

import data.generic.common as commonLib

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
	selector := commonLib.find_selector_by_value(filter, value)
	commonLib.get_operator(selector) == op
	commonLib.get_selector_name(selector) == name
}

# { ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }
check_expression_missing(resName, filter, doc) {
	alarm := doc.resource.aws_cloudwatch_metric_alarm[name]
	contains(alarm.metric_name, resName)

	count({exp | exp := expressionArr[n]; commonLib.check_selector(filter, exp.value, exp.op, exp.name) == false}) == 0
}

CxPolicy[result] {
	doc := input.document[i]
	resources := doc.resource.aws_cloudwatch_log_metric_filter

	allPatternsCount := count([x | [path, value] := walk(resources); filter := commonLib.json_unmarshal(value.pattern); x = filter])
	count([filter | [path, value] := walk(resources); filter := commonLib.json_unmarshal(value.pattern); not check_expression_missing(path[0], filter, doc)]) == allPatternsCount

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudwatch_log_metric_filter",
		"resourceName": "unknown",
		"searchKey": "resource",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern { ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) } and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern { ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) } or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": commonLib.build_search_line([], []),
	}
}
