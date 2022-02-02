package Cx

import data.generic.common as common_lib
import data.generic.terraform as terraform_lib

get_matching_action(action, statements) = matched_action {
	match = common_lib.policy_allows_action(statements, action)
	match == true
	matched_action = action
}

# This query only evaluates allowance of set of privileged actions within a given policy context.
# It does not evaluate wholistically across all attached policies.
# It considers only presence of certain set of actions and it's allowance 
# in the policy without the context of which resource(s) it applies to.

CxPolicy[result] {
	# For Inline Policy attachment
	document = input.document
	lambda = document[l].resource.aws_lambda_function[function_id]
	# Checking for role whose id matches in the role of lambda arn reference
	role = document[r].resource.aws_iam_role[role_id]
	terraform_lib.has_relation(role_id, "aws_iam_role", lambda, "role")
	# Checking for role's reference in inline policy
	inline_policy = document[p].resource.aws_iam_role_policy[inline_policy_id]
	terraform_lib.has_relation(role_id, "aws_iam_role", inline_policy, "role")
	inline_policy_json = common_lib.json_unmarshal(inline_policy.policy)
	parseable_policy = common_lib.make_regex_compatible_policy_statement(inline_policy_json.Statement)
	actions := data.common_lib.aws_privilege_escalation_actions
	matching_actions := {get_matching_action(action, parseable_policy)| action:= actions[_]}
	matching_actions != set()
	result := {
		"documentId": document[l].id,
		"searchKey": sprintf("aws_lambda_function[%s].role", [function_id]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].role has no privileged permissions through attached inline policy.", [function_id]),
		"keyActualValue": sprintf("aws_lambda_function[%s].role has been provided privileged permissions through attached inline policy. Provided privileged permissions: '%v'", [function_id, concat("' , '",matching_actions)]),
	}
}

CxPolicy[result] {
	document = input.document
	# For Customer Managed Policy Attachment (i.e defined within the current terraform template)
	lambda = document[l].resource.aws_lambda_function[function_id]
	# Checking for role whose id matches in the role of lambda arn reference
	role = document[r].resource.aws_iam_role[role_id]
	terraform_lib.has_relation(role_id, "aws_iam_role", lambda, "role")
	attached_customer_managed_policy_ids := terraform_lib.get_attached_managed_policy_ids(role_id, "role", input)
	attached_customer_managed_policy_id = attached_customer_managed_policy_ids[_]
	not regex.match("arn:aws.*:iam::.*", attached_customer_managed_policy_id)
	customer_managed_policy = document[p].resource.aws_iam_policy[attached_customer_managed_policy_id]
	customer_managed_policy_json = common_lib.json_unmarshal(customer_managed_policy.policy)
	parseable_policy = common_lib.make_regex_compatible_policy_statement(customer_managed_policy_json.Statement)
	actions := data.common_lib.aws_privilege_escalation_actions
	matching_actions := {get_matching_action(action, parseable_policy)| action:= actions[_]}
	matching_actions != set()
	result := {
		"documentId": document[l].id,
		"searchKey": sprintf("aws_lambda_function[%s].role", [function_id]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].role has no privileged permissions through attached managed policy", [function_id]),
		"keyActualValue": sprintf("aws_lambda_function[%s].role has been provided privileged permissions through attached managed policy '%v'. Provided privileged permissions: '%v'", [function_id, attached_customer_managed_policy_id,  concat("' , '",matching_actions)]),
	}
}

CxPolicy[result] {
	document = input.document
	# For Pre-existing Managed Policy Attachment (i.e not defined within the current terraform template and hard coded as just policy arn)
	lambda = document[l].resource.aws_lambda_function[function_id]
	# Checking for role whose id matches in the role of lambda arn reference
	role = document[r].resource.aws_iam_role[role_id]
	terraform_lib.has_relation(role_id, "aws_iam_role", lambda, "role")
	attached_aws_managed_policy_arns := terraform_lib.get_attached_managed_policy_ids(role_id, "role", input)
	attached_customer_managed_policy_id = attached_aws_managed_policy_arns[_]
	# Looking up of privileged policy_arns
	regex.match(sprintf("arn:aws.*:iam::policy/%s", [data.common_lib.aws_privilege_escalation_policy_names[_]]), attached_customer_managed_policy_id)
	result := {
		"documentId": document[l].id,
		"searchKey": sprintf("aws_lambda_function[%s].role", [function_id]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].role has no privileged permissions", [function_id]),
		"keyActualValue": sprintf("aws_lambda_function[%s].role has been provided privileged permissions through attached pre-existing managed policy '%v'.", [function_id, attached_customer_managed_policy_id]),
	}
}