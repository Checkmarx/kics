package Cx

import data.generic.common as common_lib

expressionArr := [
	{
		"op": "=",
		"value": "organizations.amazonaws.com",
		"name": "$.eventSource",
	},
	{
		"op": "=",
		"value": "AcceptHandshake",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "AttachPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "CreateAccount",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "PutBucketLifecycle",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "CreateOrganizationalUnit",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "CreatePolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeclineHandshake",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteOrganization",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeleteOrganizationalUnit",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DeletePolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DetachPolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "DisablePolicyType",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "EnablePolicyType",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "InviteAccountToOrganization",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "LeaveOrganization",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "MoveAccount",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "RemoveAccountFromOrganization",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "UpdatePolicy",
		"name": "$.eventName",
	},
	{
		"op": "=",
		"value": "UpdateOrganizationalUni",
		"name": "$.eventName",
	},
]

check_selector(filter, value, op, name) {
	selector := common_lib.find_selector_by_value(filter, value)
	selector._op == op
	selector._selector == name
}

# { ($.eventSource = \"organizations.amazonaws.com\") && (($.eventName = AcceptHandshake) || ($.eventName = AttachPolicy) || ($.eventName = CreateAccount) || ($.eventName = PutBucketLifecycle) || ($.eventName = CreateOrganizationalUnit) || ($.eventName = CreatePolicy) || ($.eventName = DeclineHandshake) || ($.eventName = DeleteOrganization) || ($.eventName = DeleteOrganizationalUnit) || ($.eventName = DeletePolicy) || ($.eventName = DetachPolicy) || ($.eventName = DisablePolicyType) || ($.eventName = EnablePolicyType) || ($.eventName = InviteAccountToOrganization) || ($.eventName = LeaveOrganization) || ($.eventName = MoveAccount) || ($.eventName = RemoveAccountFromOrganization) || ($.eventName = UpdatePolicy) || ($.eventName = UpdateOrganizationalUni)) }
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
		"keyExpectedValue": "aws_cloudwatch_log_metric_filter should have pattern { ($.eventSource = \"organizations.amazonaws.com\") && (($.eventName = AcceptHandshake) || ($.eventName = AttachPolicy) || ($.eventName = CreateAccount) || ($.eventName = PutBucketLifecycle) || ($.eventName = CreateOrganizationalUnit) || ($.eventName = CreatePolicy) || ($.eventName = DeclineHandshake) || ($.eventName = DeleteOrganization) || ($.eventName = DeleteOrganizationalUnit) || ($.eventName = DeletePolicy) || ($.eventName = DetachPolicy) || ($.eventName = DisablePolicyType) || ($.eventName = EnablePolicyType) || ($.eventName = InviteAccountToOrganization) || ($.eventName = LeaveOrganization) || ($.eventName = MoveAccount) || ($.eventName = RemoveAccountFromOrganization) || ($.eventName = UpdatePolicy) || ($.eventName = UpdateOrganizationalUni)) } and be associated an aws_cloudwatch_metric_alarm",
		"keyActualValue": "aws_cloudwatch_log_metric_filter not filtering pattern { ($.eventSource = \"organizations.amazonaws.com\") && (($.eventName = AcceptHandshake) || ($.eventName = AttachPolicy) || ($.eventName = CreateAccount) || ($.eventName = PutBucketLifecycle) || ($.eventName = CreateOrganizationalUnit) || ($.eventName = CreatePolicy) || ($.eventName = DeclineHandshake) || ($.eventName = DeleteOrganization) || ($.eventName = DeleteOrganizationalUnit) || ($.eventName = DeletePolicy) || ($.eventName = DetachPolicy) || ($.eventName = DisablePolicyType) || ($.eventName = EnablePolicyType) || ($.eventName = InviteAccountToOrganization) || ($.eventName = LeaveOrganization) || ($.eventName = MoveAccount) || ($.eventName = RemoveAccountFromOrganization) || ($.eventName = UpdatePolicy) || ($.eventName = UpdateOrganizationalUni)) } or not associated with any aws_cloudwatch_metric_alarm",
		"searchLine": common_lib.build_search_line([], []),
	}
}
