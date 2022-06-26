package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	# get a AWS IAM role
	input.document[i].resource.aws_iam_role[targetRole]

    unrecommended_permission_policy_scenarios(targetRole, "iam:AddUserToGroup")
    

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s]", [targetRole]),
		"issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("role %s is not associated with a policy that has Action set to 'iam:AddUserToGroup' and Resource set to '*'", [targetRole]),
		"keyActualValue": sprintf("role %s is associated with a policy that has Action set to 'iam:AddUserToGroup' and Resource set to '*'", [targetRole]),
        "searchLine": common_lib.build_search_line(["resource", "aws_iam_role", targetRole], []),
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

get_role(attachment) = role {
	role := split(attachment.roles[_], ".")[1]
} else = role {
	role := split(attachment.role, ".")[1]
}


unrecommended_permission_policy_scenarios(targetRole, permission) {
 	# get the IAM role policy
 	rolePolicy := input.document[_].resource.aws_iam_role_policy[_]
    
    # get the role referenced in IAM role policy and confirm it is the target role
    role := split(rolePolicy.role, ".")[1]
    role == targetRole
    
    # verify that the policy is unrecommended
    unrecommended_permission_policy(rolePolicy, permission)
} else {
 
    # find attachment
    attachments := {"aws_iam_policy_attachment", "aws_iam_role_policy_attachment"} 
    attachment := input.document[_].resource[attachments[_]][_]
    
    # get the role referenced in IAM policy attachment and confirm it is the target role
    role := get_role(attachment)
    role == targetRole
    
    # confirm that policy associated is unrecommend
    policy := split(attachment.policy_arn, ".")[1]
   
    policies := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
    resourcePolicy := input.document[_].resource[policies[_]][policy]
    
    # verify that the policy is unrecommended
    unrecommended_permission_policy(resourcePolicy, permission)
    
}
 