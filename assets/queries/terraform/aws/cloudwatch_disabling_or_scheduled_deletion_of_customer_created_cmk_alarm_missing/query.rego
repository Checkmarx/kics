package Cx

import data.generic.common as commonLib

expressionArr := [
	{
		"op": "=",
		"value": "kms.amazonaws.com",
		"name": "$.eventSource",
	},
	{
		"op": "=",
		"value": "DisableKey",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "ScheduleKeyDeletion",
		"name": "$.eventName",
	},
]

# { ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }
check_expression_missing(resName, filter, doc) {
	alarm := doc.resource.aws_cloudwatch_metric_alarm[name]
	contains(alarm.metric_name, resName)
	expr := commonLib.get_kics_filter_expr(filter)
	commonLib.get_operator(expr) == "&&"

	count({exp | exp := expressionArr[n]; commonLib.check_selector(filter, exp.value, exp.op, exp.name) == false}) == 0
}

CxPolicy[result] {
	doc := input.document[i]
	resources := doc.resource.aws_cloudwatch_log_metric_filter

	allPatternsCount := count([filter | [path, value] := walk(resources); filter := commonLib.json_unmarshal(value.pattern)])
	count([filter | [path, value] := walk(resources); filter := commonLib.json_unmarshal(value.pattern); not check_expression_missing(path[0], filter, doc)]) == allPatternsCount

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudwatch_log_metric_filter",
		"resourceName": "unknown",
		"searchKey": "resource",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) } and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) } or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": commonLib.build_search_line([], []),
	}
}
