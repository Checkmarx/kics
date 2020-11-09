package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_s3_bucket[name]
    out := json.unmarshal(resource.policy)
    out.Statement[ix].Effect = "Allow"
    action := out.Statement[ix].Action

    is_string(action)
    contains(action, "*")

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].policy.Statement.Action", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
                "keyActualValue": 	"'policy.Statement.Action' contain '*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            resource.bucket
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_s3_bucket[name]
    out := json.unmarshal(resource.policy)
    out.Statement[ix].Effect = "Allow"
    action := out.Statement[ix].Action

    is_array(action)
    contains(action[_], "*")

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].policy.Statement.Action", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
                "keyActualValue": 	"'policy.Statement.Action' contain '*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            resource.bucket
              }
}
