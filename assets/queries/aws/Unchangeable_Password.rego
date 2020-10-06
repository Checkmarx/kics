package Cx

SupportedResources = "$.resource.aws_iam_account_password_policy"

#allow_users_to_change_password default is true
CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    pol.allow_users_to_change_password = false

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].allow_users_to_change_password", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "true",
                "keyActualValue": 	"false"
              })
}
