package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	# get a AWS IAM group
	input.document[i].resource.aws_iam_group[targetGroup]

    unrecommended_permission_policy_scenarios(targetGroup, "lambda:CreateFunction")
    unrecommended_permission_policy_scenarios(targetGroup, "iam:PassRole")
        unrecommended_permission_policy_scenarios(targetGroup, "lambda:InvokeFunction")
    

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_group[%s]", [targetGroup]),
		"issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("group %s is not associated with a policy that has Action set to 'lambda:CreateFunction' and 'iam:PassRole' and 'lambda:InvokeFunction' and Resource set to '*'", [targetGroup]),
		"keyActualValue": sprintf("group %s is associated with a policy that has Action set to 'lambda:CreateFunction' and 'iam:PassRole' and 'lambda:InvokeFunction' and Resource set to '*'", [targetGroup]),
        "searchLine": common_lib.build_search_line(["resource", "aws_iam_group", targetGroup], []),
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

get_group(attachment) = group {
	group := split(attachment.groups[_], ".")[1]
} else = group {
	group := split(attachment.group, ".")[1]
}


unrecommended_permission_policy_scenarios(targetGroup, permission) {
 	# get the IAM group policy
 	groupPolicy := input.document[_].resource.aws_iam_group_policy[_]
    
    # get the group referenced in IAM group policy and confirm it is the target group
    group := split(groupPolicy.group, ".")[1]
    group == targetGroup
    
    # verify that the policy is unrecommended
    unrecommended_permission_policy(groupPolicy, permission)
} else {
 
    # find attachment
    attachments := {"aws_iam_policy_attachment", "aws_iam_group_policy_attachment"} 
    attachment := input.document[_].resource[attachments[_]][_]
    
    # get the group referenced in IAM policy attachment and confirm it is the target group
    group := get_group(attachment)
    group == targetGroup
    
    # confirm that policy associated is unrecommend
    policy := split(attachment.policy_arn, ".")[1]
   
    policies := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy"}
    resourcePolicy := input.document[_].resource[policies[_]][policy]
    
    # verify that the policy is unrecommended
    unrecommended_permission_policy(resourcePolicy, permission)
    
}
 