package Cx

CxPolicy [ result ] {
    pol := input.file[i].resource.aws_ecr_repository_policy[name].policy
    re_match("\"Principal\"\\s*:\\s*\"*\"", pol)

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_ecr_repository_policy[%s].policy", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Principal' is not equal '*'",
                "keyActualValue": 	"'policy.Principal' is equal '*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
