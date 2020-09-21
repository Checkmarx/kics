package Cx

SupportedResources = "$.resource.aws_iam_account_password_policy"

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    object.get(pol, "password_reuse_prevention", "not found") == "not found"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].password_reuse_prevention", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": 5,
                "keyActualValue": 	null
              })
}

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    pol.password_reuse_prevention = false

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].password_reuse_prevention", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": 5,
                "keyActualValue": 	"false"
              })
}

