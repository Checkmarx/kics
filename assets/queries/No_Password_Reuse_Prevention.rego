package Cx

SupportedResources = "$.resource.aws_iam_account_password_policy"

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    object.get(pol, "password_reuse_prevention", "not found") == "not found"

    result := {
                "foundKye": 		pol,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_iam_account_password_policy", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"password_reuse_prevention",
                "keyExpectedValue": 5,
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
                "keyName":			"password_reuse_prevention",
                "keyExpectedValue": 5,
                "keyActualValue": 	"false",
                #{metadata}
              }
}

