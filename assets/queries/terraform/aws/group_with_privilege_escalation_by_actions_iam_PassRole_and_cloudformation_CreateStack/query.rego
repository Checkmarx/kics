package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {

	# get a AWS IAM group
	group := input.document[i].resource.aws_iam_group[targetGroup]

    common_lib.group_unrecommended_permission_policy_scenarios(targetGroup, "cloudformation:CreateStack")
    common_lib.group_unrecommended_permission_policy_scenarios(targetGroup, "iam:PassRole")


	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_group",
        "resourceName": tf_lib.get_resource_name(group, targetGroup),
		"searchKey": sprintf("aws_iam_group[%s]", [targetGroup]),
		"issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("group %s shouldn't be associated with a policy that has Action set to 'cloudformation:CreateStack' and 'iam:PassRole' and Resource set to '*'", [targetGroup]),
		"keyActualValue": sprintf("group %s is associated with a policy that has Action set to 'cloudformation:CreateStack' and 'iam:PassRole' and Resource set to '*'", [targetGroup]),
        "searchLine": common_lib.build_search_line(["resource", "aws_iam_group", targetGroup], []),
	}
}
