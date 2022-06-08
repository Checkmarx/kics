package Cx

import data.generic.common as commonLib

expressionArr := [
	{
		"op": "=",
		"value": "CreateVpc",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteVpc",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "ModifyVpcAttribute",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "AcceptVpcPeeringConnection",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "CreateVpcPeeringConnection",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteVpcPeeringConnection",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "RejectVpcPeeringConnection",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "AttachClassicLinkVpc",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DetachClassicLinkVpc",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DisableVpcClassicLink",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "EnableVpcClassicLink",
		"name": "$.eventName",
	},
]

# { ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }
check_expression_missing(resName, filter, doc) {
	alarm := doc.resource.aws_cloudwatch_metric_alarm[name]
	contains(alarm.metric_name, resName)
	filter._kics_filter_expr._op == "||"
	count({x | exp := expressionArr[n]; commonLib.check_selector(filter, exp.value, exp.op, exp.name) == false; x := exp}) == 0
}

CxPolicy[result] {
	doc := input.document[i]
	resources := doc.resource.aws_cloudwatch_log_metric_filter

	allPatternsCount := count([x | [path, value] := walk(resources); filter := commonLib.json_unmarshal(value.pattern); x = filter])
	count([x | [path, value] := walk(resources); filter := commonLib.json_unmarshal(value.pattern); not check_expression_missing(path[0], filter, doc); x = filter]) == allPatternsCount

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_cloudwatch_log_metric_filter",
		"resourceName": "unknown",
		"searchKey": "resource",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern { ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) } and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern { ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) } or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": commonLib.build_search_line([], []),
	}
}
