package Cx

import data.generic.common as commonLib

# { $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }
check_expression_missing(resName, filter, doc) {
	alarm := doc.resource.aws_cloudwatch_metric_alarm[name]
	contains(alarm.metric_name, resName)
	selector1 := commonLib.find_selector_by_value(filter, "Root")
	selector1._op == "="
	selector1._selector == "$.userIdentity.type"
	selector2 := commonLib.find_selector_by_value(filter, "EXISTS")
	selector2._op == "NOT"
	selector2._selector == "$.userIdentity.invokedBy"
	selector3 := commonLib.find_selector_by_value(filter, "\"AwsServiceEvent\"")
	selector3._op == "!="
	selector3._selector == "$.eventType"
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
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern { $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" } and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern { $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" } or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": commonLib.build_search_line([], []),
	}
}
