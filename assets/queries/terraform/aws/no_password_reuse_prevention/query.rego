package Cx

CxPolicy [ result ] {
    pol := input.file[i].resource.aws_iam_account_password_policy[name]
    object.get(pol, "password_reuse_prevention", "not found") == "not found"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].password_reuse_prevention", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'password_reuse_prevention' exists",
                "keyActualValue": 	"'password_reuse_prevention' is missing",
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
    pol.password_reuse_prevention = false

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].password_reuse_prevention", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'password_reuse_prevention' is equal 'true'",
                "keyActualValue": 	"'password_reuse_prevention' is equal 'false'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

