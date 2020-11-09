package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_iam_policy_attachment[name]
    resource.user

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_policy_attachment[%s].user", [name]),
                "issueType":		"RedundantAttribute",
                "keyExpectedValue": "'user' is redundant",
                "keyActualValue": 	"'user' exists",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
