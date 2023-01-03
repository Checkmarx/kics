package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

	# get a AWS IAM role
	role := input.document[i].resource.aws_iam_role[targetRole]

    common_lib.role_unrecommended_permission_policy_scenarios(targetRole, "iam:AttachGroupPolicy")


	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_role",
        "resourceName": tf_lib.get_resource_name(role, targetRole),
		"searchKey": sprintf("aws_iam_role[%s]", [targetRole]),
		"issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("role %s shouldn't be associated with a policy that has Action set to 'iam:AttachGroupPolicy' and Resource set to '*'", [targetRole]),
		"keyActualValue": sprintf("role %s is associated with a policy that has Action set to 'iam:AttachGroupPolicy' and Resource set to '*'", [targetRole]),
        "searchLine": common_lib.build_search_line(["resource", "aws_iam_role", targetRole], []),
	}
}
