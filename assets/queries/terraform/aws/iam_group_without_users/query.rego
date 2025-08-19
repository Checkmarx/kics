package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	iam_group := input.document[i].resource.aws_iam_group[name]

	without_users(name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_group",
		"resourceName": tf_lib.get_resource_name(iam_group, name),
		"searchKey": sprintf("aws_iam_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_group[%s] should be associated with an aws_iam_group_membership that has at least one user set", [name]),
		"keyActualValue": sprintf("aws_iam_group[%s] is not associated with an aws_iam_group_membership that has at least one user set", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_iam_group", name], [])
	}
}

without_users(name) {
	count({x |
        resource := input.document[x].resource.aws_iam_group_membership;
        has_group_membership_associated(resource, name);
        not empty(resource)
    }) == 0
	count({y |
        resource := input.document[y].resource.aws_iam_user_group_membership;
        has_user_group_membership_associated(resource, name)
    }) == 0
}

has_group_membership_associated(resource, name) {
    resource[_].group == sprintf("${aws_iam_group.%s.name}", [name])
}

has_user_group_membership_associated(resource, name) {
    common_lib.equalsOrInArray(resource[_].groups, sprintf("${aws_iam_group.%s.name}", [name]))
}

empty(resource) {
	count(resource[_].users) == 0
}
