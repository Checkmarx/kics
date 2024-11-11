package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	# get a AWS IAM group
	some doc in input.document
	group := doc.resource.aws_iam_group[targetGroup]

	common_lib.group_unrecommended_permission_policy_scenarios(targetGroup, "glue:CreateDevEndpoint")
	common_lib.group_unrecommended_permission_policy_scenarios(targetGroup, "iam:PassRole")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_iam_group",
		"resourceName": tf_lib.get_resource_name(group, targetGroup),
		"searchKey": sprintf("aws_iam_group[%s]", [targetGroup]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("group %s shouldn't be associated with a policy that has Action set to 'glue:CreateDevEndpoint' and 'iam:PassRole' and Resource set to '*'", [targetGroup]),
		"keyActualValue": sprintf("group %s is associated with a policy that has Action set to 'glue:CreateDevEndpoint' and 'iam:PassRole' and Resource set to '*'", [targetGroup]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_group", targetGroup], []),
	}
}
