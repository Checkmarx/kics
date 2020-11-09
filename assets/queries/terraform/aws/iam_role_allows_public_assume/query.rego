package Cx

CxPolicy [ result ] {
	policy := input.file[i].resource.aws_iam_role[name].assume_role_policy
    re_match("Service", policy)
    out := json.unmarshal(policy)
    not out.Statement[ix].Effect
    aws := out.Statement[ix].Principal.AWS
    contains(aws, "*")

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'assume_role_policy.Statement.Principal.AWS' doesn't contain '*'",
                "keyActualValue": 	"'assume_role_policy.Statement.Principal.AWS' contains '*'",
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
	policy := input.file[i].resource.aws_iam_role[name].assume_role_policy
    re_match("Service", policy)
    out := json.unmarshal(policy)
    out.Statement[ix].Effect != "Deny"
    aws := out.Statement[ix].Principal.AWS
    contains(aws, "*")

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'assume_role_policy.Statement.Principal.AWS' doesn't contain '*'",
                "keyActualValue": 	"'assume_role_policy.Statement.Principal.AWS' contains '*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

