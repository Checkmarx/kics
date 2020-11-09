package Cx

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.file[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    pol.Statement[idx].Principal = "*"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Principal", [pl[r], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Principal' is not equal '*'",
                "keyActualValue": 	"'policy.Statement.Principal' is equal '*'",
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
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.file[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    contains(pol.Statement[idx].Principal.AWS, "*")

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Principal.AWS", [pl[r], name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'policy.Statement.Principal.AWS' doesn't contain '*'",
                "keyActualValue": 	"'policy.Statement.Principal.AWS' contains '*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
