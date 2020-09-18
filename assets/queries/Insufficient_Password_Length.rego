package Cx

SupportedResources = "$.resource.aws_iam_account_password_policy"

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    not pol.minimum_password_length

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_iam_account_password_policy[%s].minimum_password_length", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": 8,
                "keyActualValue": 	null
              })
}

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    pol.minimum_password_length < 8

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_iam_account_password_policy[%s].minimum_password_length", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": 8,
                "keyActualValue": 	pol.minimum_password_length
              })
}
