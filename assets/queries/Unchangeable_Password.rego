package Cx

SupportedResources = "$.resource.aws_iam_account_password_policy"

#allow_users_to_change_password default is true
CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    pol.allow_users_to_change_password = false

    result := {
                "foundKye": 		pol,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_iam_account_password_policy", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}
