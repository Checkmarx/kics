package Cx

CxPolicy [ result ] {
    pol := input.file[i].resource.aws_iam_account_password_policy[name]
    not pol.minimum_password_length

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].minimum_password_length", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'minimum_password_length' exists",
                "keyActualValue": 	"'minimum_password_length' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

CxPolicy [ result ] {
    pol := input.file[i].resource.aws_iam_account_password_policy[name]
    pol.minimum_password_length < 8

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].minimum_password_length", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'minimum_password_length' is higher 8",
                "keyActualValue": 	"'minimum_password_length' is lower 8",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
