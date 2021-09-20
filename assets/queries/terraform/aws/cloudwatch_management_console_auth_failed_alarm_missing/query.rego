package Cx

import data.generic.common as commonLib

# { $.eventName = ConsoleLogin && $.errorMessage = \"Failed authentication\" }
check_expression_missing(resName, filter, doc) {
	alarm := doc.resource.aws_cloudwatch_metric_alarm[name]
	contains(alarm.metric_name, resName)
	filter._kics_filter_expr._op == "&&"
	selector1 := commonLib.find_selector_by_value(filter, "ConsoleLogin")
	selector1._op == "="
	selector1._selector == "$.eventName"
	selector2 := commonLib.find_selector_by_value(filter, "\"Failed authentication\"")
	selector2._op == "="
	selector2._selector == "$.errorMessage"
}

CxPolicy[result] {
	doc := input.document[i]
	resources := doc.resource.aws_cloudwatch_log_metric_filter

	allPatternsCount := count([x | [path, value] := walk(resources); filter := commonLib.json_unmarshal(value.pattern); x = filter])
	count([x | [path, value] := walk(resources); filter := commonLib.json_unmarshal(value.pattern); not check_expression_missing(path[0], filter, doc); x = filter]) == allPatternsCount

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resource",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern { $.eventName = ConsoleLogin && $.errorMessage = \"Failed authentication\" } and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern { $.eventName = ConsoleLogin && $.errorMessage = \"Failed authentication\" } or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": commonLib.build_search_line([], []),
	}
}
