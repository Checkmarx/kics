package Cx

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    not pol.minimum_password_length

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].minimum_password_length", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'minimum_password_length' exists",
                "keyActualValue": 	"'minimum_password_length' is missing"
              }
}

CxPolicy [ result ] {
    pol := input.document[i].resource.aws_iam_account_password_policy[name]
    pol.minimum_password_length < 8

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].minimum_password_length", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'minimum_password_length' is higher 8",
                "keyActualValue": 	"'minimum_password_length' is lower 8"
              }
}
