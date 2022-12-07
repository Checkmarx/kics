package Cx

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
	}
}

without_users(name) {
	count({x | resource := input.document[x].resource.aws_iam_group_membership; has_membership_associated(resource, name); not empty(resource)}) == 0
}

has_membership_associated(resource, name) {
	attributeSplit := split(resource[_].group, ".")
	attributeSplit[1] == name
}

empty(resource) {
	count(resource[_].users) == 0
}
