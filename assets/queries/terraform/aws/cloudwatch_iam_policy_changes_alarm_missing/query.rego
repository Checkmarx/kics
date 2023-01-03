package Cx

import data.generic.common as common_lib

expressionArr := [
	{
		"op": "=",
		"value": "DeleteGroupPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteRolePolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteUserPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "PutGroupPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "PutRolePolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "PutUserPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "CreatePolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeletePolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "CreatePolicyVersion",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeletePolicyVersion",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "AttachRolePolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DetachRolePolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "AttachUserPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DetachUserPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "AttachGroupPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DetachGroupPolicy",
		"name": "$.eventName",
	},
]

check_selector(filter, value, op, name) {
	selector := common_lib.find_selector_by_value(filter, value)
	selector._op == op
	selector._selector == name
}

# {($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}
check_expression_missing(resName, filter, doc) {
	alarm := doc.resource.aws_cloudwatch_metric_alarm[name]
	contains(alarm.metric_name, resName)

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
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern {($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)} and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern {($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)} or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": common_lib.build_search_line([], []),
	}
}
