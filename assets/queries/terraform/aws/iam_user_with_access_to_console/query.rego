package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_iam_user_login_profile[name]
	user := resource.user
	search := clean_user(user)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s", [search[0][1]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s doesn't have aws_iam_user_login_profile", [search[0][1]]),
		"keyActualValue": sprintf("%s has aws_iam_user_login_profile", [search[0][1]]),
	}
}

clean_user(user) = search {
	search := regex.find_all_string_submatch_n("\\${(.*?)\\}", user, -1)
}
