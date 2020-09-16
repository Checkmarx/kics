package Cx

SupportedResources = "$.resource.aws_iam_account_password_policy"

CxPolicy [ result ] {
    expr := input.document[i].resource.aws_iam_account_password_policy[name]
    not expr.max_password_age

    result := {
                "foundKye": 		expr,
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

CxPolicy [ result ] {
    expr := input.document[i].resource.aws_iam_account_password_policy[name]
    expr.max_password_age > 90

    result := {
                "foundKye": 		expr,
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
