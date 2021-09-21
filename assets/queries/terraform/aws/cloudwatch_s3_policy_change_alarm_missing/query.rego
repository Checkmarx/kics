package Cx

import data.generic.common as commonLib

expressionArr := [
	{
		"op": "=",
		"value": "s3.amazonaws.com",
		"name": "$.eventSource",
	},
	{
		"op": "=",
		"value": "PutBucketAcl",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "PutBucketPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "PutBucketCors",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "PutBucketLifecycle",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "PutBucketReplication",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteBucketPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteBucketCors",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteBucketLifecycle",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteBucketReplication",
		"name": "$.eventName",
	},
]

# { ($.eventSource = \"s3.amazonaws.com\")
# && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy)
# || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) ||
# ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) ||
# ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) ||
# ($.eventName = DeleteBucketReplication)) }
check_expression_missing(resName, filter, doc) {
	alarm := doc.resource.aws_cloudwatch_metric_alarm[name]
	contains(alarm.metric_name, resName)

	filter._kics_filter_expr._op == "&&"

	count({x | exp := expressionArr[n]; commonLib.check_selector(filter, exp.value, exp.op, exp.name) == false; x := exp}) == 0
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
