package Cx

CxPolicy[result] {
	iam_group := input.document[i].resource.aws_iam_group[name]

	without_users(name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_iam_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_iam_group[%s] is associated with an aws_iam_group_membership that has at least one user set", [name]),
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
	resource[_].users == null
}
