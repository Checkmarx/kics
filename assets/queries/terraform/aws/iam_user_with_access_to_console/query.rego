package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_iam_user_login_profile[name]
	user := resource.user
	search := clean_user(user)

	result := {
		"documentId": doc.id,
		"resourceType": "aws_iam_user_login_profile",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s", [search[0][1]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s shouldn't have aws_iam_user_login_profile", [search[0][1]]),
		"keyActualValue": sprintf("%s has aws_iam_user_login_profile", [search[0][1]]),
	}
}

clean_user(user) = regex.find_all_string_submatch_n(`\${(.*?)\}`, user, -1)
