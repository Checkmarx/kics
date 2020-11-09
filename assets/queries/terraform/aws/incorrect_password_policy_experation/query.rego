package Cx

CxPolicy [ result ] {
    expr := input.file[i].resource.aws_iam_account_password_policy[name]
    not expr.max_password_age

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].max_password_age", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'max_password_age' exists",
                "keyActualValue": 	"'max_password_age' is missing",
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
    expr := input.file[i].resource.aws_iam_account_password_policy[name]
    expr.max_password_age > 90

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].max_password_age", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'max_password_age' is lower 90",
                "keyActualValue": 	"'max_password_age' is higher 90",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
