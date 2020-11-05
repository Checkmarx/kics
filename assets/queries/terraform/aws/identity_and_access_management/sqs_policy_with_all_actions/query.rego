package Cx

CxPolicy [ result ] {
    policy := input.document[i].resource.aws_sqs_queue_policy[name].policy
    out := json.unmarshal(policy)
    out.Statement[idx].Action = "*"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Action", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Action' is not equal '*'",
                "keyActualValue": 	"'policy.Statement.Action' is equal '*'"
              }
}
