package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	# get a AWS IAM user
	input.document[i].resource.aws_iam_user[targetUser]

    common_lib.user_unrecommended_permission_policy_scenarios(targetUser, "iam:AddUserToGroup")


	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_user[%s]", [targetUser]),
		"issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("user %s is not associated with a policy that has Action set to 'iam:AddUserToGroup' and Resource set to '*'", [targetUser]),
		"keyActualValue": sprintf("user %s is associated with a policy that has Action set to 'iam:AddUserToGroup' and Resource set to '*'", [targetUser]),
        "searchLine": common_lib.build_search_line(["resource", "aws_iam_user", targetUser], []),
	}
}
