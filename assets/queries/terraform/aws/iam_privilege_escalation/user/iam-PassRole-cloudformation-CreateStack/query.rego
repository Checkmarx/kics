package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	# get a AWS IAM user
	input.document[i].resource.aws_iam_user[targetUser]

    unrecommended_permission_policy_scenarios(targetUser, "cloudformation:CreateStack")
    unrecommended_permission_policy_scenarios(targetUser, "iam:PassRole")
    

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_user[%s]", [targetUser]),
		"issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("user %s is not associated with a policy that has Action set to 'cloudformation:CreateStack' and 'iam:PassRole' and Resource set to '*'", [targetUser]),
		"keyActualValue": sprintf("user %s is associated with a policy that has Action set to 'cloudformation:CreateStack' and 'iam:PassRole' and Resource set to '*'", [targetUser]),
        "searchLine": common_lib.build_search_line(["resource", "aws_iam_user", targetUser], []),
	}
}


unrecommended_permission_policy(resourcePolicy, permission) {
    policy := common_lib.json_unmarshal(resourcePolicy.policy)
    
    st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
    
    common_lib.equalsOrInArray(statement.Resource, "*")
    common_lib.equalsOrInArray(statement.Action, lower(permission))
}

get_user(attachment) = user {
	user := split(attachment.users[_], ".")[1]
} else = user {
	user := split(attachment.user, ".")[1]
}


unrecommended_permission_policy_scenarios(targetUser, permission) {
 	# get the IAM user policy
 	userPolicy := input.document[_].resource.aws_iam_user_policy[_]
    
    # get the user referenced in IAM user policy and confirm it is the target user
    user := split(userPolicy.user, ".")[1]
    user == targetUser
    
    # verify that the policy is unrecommended
    unrecommended_permission_policy(userPolicy, permission)
} else {
 
    # find attachment
    attachments := {"aws_iam_policy_attachment", "aws_iam_user_policy_attachment"} 
    attachment := input.document[_].resource[attachments[_]][_]
    
    # get the user referenced in IAM policy attachment and confirm it is the target user
    user := get_user(attachment)
    user == targetUser
    
    # confirm that policy associated is unrecommend
    policy := split(attachment.policy_arn, ".")[1]
   
    policies := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
    resourcePolicy := input.document[_].resource[policies[_]][policy]
    
    # verify that the policy is unrecommended
    unrecommended_permission_policy(resourcePolicy, permission)
    
}
 