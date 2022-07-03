package Cx

import data.generic.common as common_lib

CxPolicy[result] {

	# get a AWS IAM role
	input.document[i].resource.aws_iam_role[targetRole]

    common_lib.role_unrecommended_permission_policy_scenarios(targetRole, "cloudformation:CreateStack")
    common_lib.role_unrecommended_permission_policy_scenarios(targetRole, "iam:PassRole")


	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_role[%s]", [targetRole]),
		"issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("role %s is not associated with a policy that has Action set to 'cloudformation:CreateStack' and 'iam:PassRole' and Resource set to '*'", [targetRole]),
		"keyActualValue": sprintf("role %s is associated with a policy that has Action set to 'cloudformation:CreateStack' and 'iam:PassRole' and Resource set to '*'", [targetRole]),
        "searchLine": common_lib.build_search_line(["resource", "aws_iam_role", targetRole], []),
	}
}
