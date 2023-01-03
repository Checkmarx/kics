package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_user_login_profile[name]
	user := resource.user
	search := clean_user(user)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_iam_user_login_profile",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s", [search[0][1]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s shouldn't have aws_iam_user_login_profile", [search[0][1]]),
		"keyActualValue": sprintf("%s has aws_iam_user_login_profile", [search[0][1]]),
	}
}

clean_user(user) = search {
	search := regex.find_all_string_submatch_n("\\${(.*?)\\}", user, -1)
}
