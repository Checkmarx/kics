package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

resourcesTest = ["aws_iam_policy_attachment", "aws_iam_user_policy", "aws_iam_user_policy_attachment"]

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourcesTest[idx]][name]
	resource.user

	result := {
		"documentId": document.id,
		"resourceType": resourcesTest[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[{{%s}}].user", [resourcesTest[idx], name]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "'user' is redundant",
		"keyActualValue": "'user' exists",
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource[resourcesTest[idx]][name]
	resource.users != null
	is_array(resource.users)
	count(resource.users) > 0

	result := {
		"documentId": document.id,
		"resourceType": resourcesTest[idx],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[{{%s}}].users", [resourcesTest[idx], name]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "'users' is redundant",
		"keyActualValue": "'users' exists",
	}
}
