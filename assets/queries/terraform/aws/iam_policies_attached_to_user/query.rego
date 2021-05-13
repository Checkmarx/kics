package Cx

resourcesTest = ["aws_iam_policy_attachment", "aws_iam_user_policy", "aws_iam_user_policy_attachment"]

CxPolicy[result] {
	resource := input.document[i].resource[resourcesTest[idx]][name]
	resource.user

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[{{%s}}].user", [resourcesTest[idx], name]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "'user' is redundant",
		"keyActualValue": "'user' exists",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourcesTest[idx]][name]
	resource.users != null
	is_array(resource.users)
	count(resource.users) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[{{%s}}].users", [resourcesTest[idx], name]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "'users' is redundant",
		"keyActualValue": "'users' exists",
	}
}
