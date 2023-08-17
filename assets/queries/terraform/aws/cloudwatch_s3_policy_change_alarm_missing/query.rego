package Cx

import data.generic.common as common_lib

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

#{ ($.eventSource = \"s3.amazonaws.com\") && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }
CxPolicy[result] {
	doc := input.document[i]
	_ := doc.resource.aws_cloudwatch_log_metric_filter[name]

	
	count([alarm | alarm := doc.resource.aws_cloudwatch_metric_alarm[_]; contains(alarm.metric_name, name)]) == 0 
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudwatch_log_metric_filter",
		"resourceName": name,
		"searchKey": sprintf("aws_cloudwatch_log_metric_filter[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": common_lib.build_search_line(["resource","aws_cloudwatch_log_metric_filter", name], []),
	}
}


check_expression_missing(filter) {
	filter._kics_filter_expr._op == "&&"

	count({x | exp := expressionArr[n];
	    common_lib.check_selector(filter, exp.value, exp.op, exp.name) == false;
	    x := exp
	}) == 0
}

CxPolicy[result] {
	doc := input.document[i]
	resources := doc.resource.aws_cloudwatch_log_metric_filter

	resourceNames := [resourceName | [path, value] := walk(resources);
	    filter := common_lib.json_unmarshal(value.pattern);
	    not check_expression_missing(filter);
	    resourceName := path[count(path)-1]
	]
    
    resourceName := resourceNames[_]
    
	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudwatch_log_metric_filter",
		"resourceName": resourceName,
		"searchKey": sprintf("aws_cloudwatch_log_metric_filter.%s",[resourceName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern $.eventSource equal to `s3.amazonaws.com` and $.eventName equal to `PutBucketAcl`, `PutBucketPolicy`, `PutBucketCors`, `PutBucketLifecycle`, `PutBucketReplication`, `DeleteBucketPolicy`, `DeleteBucketCors`, `DeleteBucketLifecycle` and `DeleteBucketReplication`",
		"keyActualValue": "aws_cloudwatch_log_metric_filter with wrong pattern",
		"searchLine": common_lib.build_search_line(["resource","aws_cloudwatch_log_metric_filter", resourceName, "pattern"], []),
	}
}