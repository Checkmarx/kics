package Cx

SupportedResources = "$.resource.aws_iam_account_password_policy"

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    not pol.password_reuse_prevention

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

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    pol.password_reuse_prevention = false

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

