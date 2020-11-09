package Cx

CxPolicy [ result ] {
    policy := input.file[i].resource.aws_sqs_queue_policy[name].policy
    out := json.unmarshal(policy)
    out.Statement[idx].Action = "*"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Action", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Action' is not equal '*'",
                "keyActualValue": 	"'policy.Statement.Action' is equal '*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}
