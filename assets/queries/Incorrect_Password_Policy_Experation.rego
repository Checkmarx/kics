package Cx

SupportedResources = "$.resource.aws_iam_account_password_policy"

CxPolicy [ result ] {
    expr := input.document[i].resource.aws_iam_account_password_policy[name]
    not expr.max_password_age

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_iam_account_password_policy[%s].max_password_age", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": 90,
                "keyActualValue": 	null
              })
}

CxPolicy [ result ] {
    expr := input.document[i].resource.aws_iam_account_password_policy[name]
    expr.max_password_age > 90

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_iam_account_password_policy[%s].max_password_age", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": 90,
                "keyActualValue": 	expr.max_password_age
              })
}
