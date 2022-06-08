package Cx

import data.generic.common as common_lib

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

check_selector(filter, value, op, name) {
	selector := common_lib.find_selector_by_value(filter, value)
	selector._op == op
	selector._selector == name
}

# { ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }
check_expression_missing(resName, filter, doc) {
	alarm := doc.resource.aws_cloudwatch_metric_alarm[name]
	contains(alarm.metric_name, resName)
	filter._kics_filter_expr._op == "&&"

	count({x | exp := expressionArr[n]; common_lib.check_selector(filter, exp.value, exp.op, exp.name) == false; x := exp}) == 0
}

CxPolicy[result] {
	doc := input.document[i]
	resources := doc.resource.aws_cloudwatch_log_metric_filter
	
	allPatternsCount := count([x | [path, value] := walk(resources); filter := common_lib.json_unmarshal(value.pattern); x = filter])
	count([x | [path, value] := walk(resources); filter := common_lib.json_unmarshal(value.pattern); not check_expression_missing(path[0], filter, doc); x = filter]) == allPatternsCount

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudwatch_log_metric_filter",
		"resourceName": "unknown",
		"searchKey": "resource",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) } and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) } or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": common_lib.build_search_line([], []),
	}
}
