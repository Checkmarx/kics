package Cx

CxPolicy [ result ] {
	policy := input.file[i].resource.aws_iam_role[name].assume_role_policy
    re_match("arn:aws:iam::", policy)
    out := json.unmarshal(policy)
    aws := out.Statement[idx].Principal.AWS
    contains(aws, "arn:aws:iam::")
    contains(aws, ":root")

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'assume_role_policy.Statement.Principal.AWS' contain ':root'",
                "keyActualValue": 	"'assume_role_policy.Statement.Principal.AWS' contains ':root'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
