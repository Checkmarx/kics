package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]

	document.Resources[queuePolicyName].Type == "AWS::SQS::QueuePolicy"
	queuePolicy := document.Resources[queuePolicyName]

	policy := queuePolicy.Properties.PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]
	common_lib.is_allow_effect(statement)

	resultData := is_unsafe_statement(statement)

	result := {
		"documentId": document.id,
		"resourceType": document.Resources[queuePolicyName].Type,
		"resourceName": cf_lib.get_resource_name(document.Resources[queuePolicyName], queuePolicyName),
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument", [queuePolicyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Principal should not have wildcards when Effect=Allow and Action contains one of [SQS:AddPermission, SQS:CreateQueue, SQS:DeleteQueue, SQS:RemovePermission, SQS:TagQueue, SQS:UnTagQueue]", [queuePolicyName]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Principal has wildcards, Effect is Allow and Action contains %s", [queuePolicyName, resultData]),
		"searchLine": common_lib.build_search_line(["Resource", queuePolicyName, "Properties", "PolicyDocument"], []),
	}
}

is_unsafe_statement(stmt) = result {
	action := has_dangerous_action(stmt.Action)
	not common_lib.valid_key(stmt, "Condition")
	has_wildcard_principal(stmt.Principal)
	result := action
}

has_wildcard_principal(p) {
	is_string(p)
	has_star_or_star_after_colon(p)
} else {
	is_array(p)
	has_star_or_star_after_colon(p[v])
	result := p[v]
} else {
	is_object(p)
	is_array(p[k])
	has_star_or_star_after_colon(p[k][v])
}

has_star_or_star_after_colon(str) {
	regex.match("^(\\w*:)*\\*$", str)
}

has_dangerous_action(action) = result {
	is_string(action)
	isDangerousAction(action)
	result := action
} else = result {
	is_array(action)
	isDangerousAction(action[a])
	result := action[a]
}

isDangerousAction("SQS:AddPermission") = true

isDangerousAction("SQS:CreateQueue") = true

isDangerousAction("SQS:DeleteQueue") = true

isDangerousAction("SQS:RemovePermission") = true

isDangerousAction("SQS:TagQueue") = true

isDangerousAction("SQS:UnTagQueue") = true
