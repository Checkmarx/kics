package Cx

#allow_users_to_change_password default is true
CxPolicy [ result ] {
    pol := input.file[i].resource.aws_iam_account_password_policy[name]
    pol.allow_users_to_change_password = false

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_account_password_policy[%s].allow_users_to_change_password", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'allow_users_to_change_password' is equal 'true'",
                "keyActualValue": 	"'allow_users_to_change_password' is equal 'false'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
