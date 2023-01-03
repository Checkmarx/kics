package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

privilegeEscalationActions := data.common_lib.aws_privilege_escalation_actions

# This query only evaluates the allowance of a set of privileged actions within a given policy context.
# It does not evaluate holistically across all attached policies.
# It considers the only presence of a certain set of actions and its allowance
# in the policy without the context of which resource(s) it applies to.

CxPolicy[result] {
	# For Inline Policy attachment
	document := input.document
	lambda := document[l].resource.aws_lambda_function[function_id]

	# Checking for role whose id matches in the role of lambda arn reference
	document[r].resource.aws_iam_role[role_id]
	split(lambda.role, ".")[1] == role_id


	# Checking for role's reference in inline policy
	inline_policy := document[p].resource.aws_iam_role_policy[inline_policy_id]
	split(inline_policy.role, ".")[1] == role_id

    policy := common_lib.json_unmarshal(inline_policy.policy)
	statements := tf_lib.getStatement(policy)
    statement := statements[_]
	matching_actions := hasPrivilegedPermissions(statement)
	count(matching_actions) > 0


	result := {
		"documentId": document[l].id,
		"resourceType": "aws_lambda_function",
		"resourceName": tf_lib.get_resource_name(lambda, function_id),
		"searchKey": sprintf("aws_lambda_function[%s].role", [function_id]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].role shouldn't have privileged permissions through attached inline policy.", [function_id]),
		"keyActualValue": sprintf("aws_lambda_function[%s].role has been provided privileged permissions through attached inline policy. Provided privileged permissions: '%v'. List of privileged permissions '%v'", [function_id, concat("' , '", matching_actions), privilegeEscalationActions]),
	}
}


CxPolicy[result] {
	document = input.document
	# For Customer Managed Policy Attachment (i.e defined within the current terraform template)
	lambda = document[l].resource.aws_lambda_function[function_id]
	# Checking for role whose id matches in the role of lambda arn reference
	role = document[r].resource.aws_iam_role[role_id]
	split(lambda.role, ".")[1] == role_id


	attachments := ["aws_iam_policy_attachment", "aws_iam_role_policy_attachment"]

    attachment := document[_].resource[attachments[_]][attachment_id]
    is_attachment(attachment, role_id)


	not regex.match("arn:aws.*:iam::.*", attachment.policy_arn)

	attached_customer_managed_policy_id := split(attachment.policy_arn, ".")[1]
	customer_managed_policy = document[p].resource.aws_iam_policy[attached_customer_managed_policy_id]


	policy := common_lib.json_unmarshal(customer_managed_policy.policy)
	statements := tf_lib.getStatement(policy)
    statement := statements[_]
	matching_actions := hasPrivilegedPermissions(statement)
	count(matching_actions) > 0


	result := {
		"documentId": document[l].id,
		"resourceType": "aws_lambda_function",
		"resourceName": tf_lib.get_resource_name(lambda, function_id),
		"searchKey": sprintf("aws_lambda_function[%s].role", [function_id]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].role shouldn't have privileged permissions through attached managed policy", [function_id]),
		"keyActualValue": sprintf("aws_lambda_function[%s].role has been provided privileged permissions through attached managed policy '%v'. Provided privileged permissions: '%v'. List of privileged permissions '%v'", [function_id, attached_customer_managed_policy_id,  concat("' , '",matching_actions), privilegeEscalationActions]),
	}
}


CxPolicy[result] {
	document = input.document
	# For Pre-existing Managed Policy Attachment (i.e not defined within the current terraform template and hard coded as just policy arn)
	lambda = document[l].resource.aws_lambda_function[function_id]
	# Checking for role whose id matches in the role of lambda arn reference
	role = document[r].resource.aws_iam_role[role_id]
	split(lambda.role, ".")[1] == role_id


	attachments := ["aws_iam_policy_attachment", "aws_iam_role_policy_attachment"]

    attachment := document[_].resource[attachments[_]][attachment_id]
    is_attachment(attachment, role_id)

	# Looking up of privileged policy_arns
	regex.match(sprintf("arn:aws.*:iam::policy/%s", [data.common_lib.aws_privilege_escalation_policy_names[_]]), attachment.policy_arn)

	result := {
		"documentId": document[l].id,
		"resourceType": "aws_lambda_function",
		"resourceName": tf_lib.get_resource_name(lambda, function_id),
		"searchKey": sprintf("aws_lambda_function[%s].role", [function_id]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_lambda_function[%s].role shouldn't have privileged permissions", [function_id]),
		"keyActualValue": sprintf("aws_lambda_function[%s].role has been provided privileged permissions through attached pre-existing managed policy '%v'.", [function_id, attachment.policy_arn]),
	}
}


is_attachment(attachment, role_id) {
   split(attachment.roles[_], ".")[1] == role_id
} else {
   split(attachment.role, ".")[1] == role_id
}


hasPrivilegedPermissions(statement) = matching_actions {
	statement.Effect == "Allow"
	matching_actions := [matching_actions | action := privilegeEscalationActions[x]; common_lib.check_actions(statement, action); matching_actions := action]
} else = matching_actions {
	matching_actions := []
}

