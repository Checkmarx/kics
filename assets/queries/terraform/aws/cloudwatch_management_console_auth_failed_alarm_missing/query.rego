package Cx

import data.generic.common as commonLib

expressionArr := [
	{
		"op": "=",
		"value": "ConsoleLogin",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "Failed authentication",
		"name": "$.errorMessage",
	},
]

# { $.eventName = ConsoleLogin && $.errorMessage = \"Failed authentication\" }
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
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern { $.eventName = ConsoleLogin && $.errorMessage = \"Failed authentication\" } and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern { $.eventName = ConsoleLogin && $.errorMessage = \"Failed authentication\" } or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": commonLib.build_search_line([], []),
	}
}
