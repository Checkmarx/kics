package Cx

SupportedResources = "$.resource.aws_sqs_queue_policy"

CxPolicy [ result ] {
	policy := input.document[i].resource.aws_sqs_queue_policy[name].policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect == "Allow"
    contains(out.Statement[ix].Action, "*")
    aws := out.Statement[ix].Principal.AWS
    contains(aws, "*")

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Statement.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT *",
                "keyActualValue":   aws
              })
}

CxPolicy [ result ] {
	policy := input.document[i].resource.aws_sqs_queue_policy[name].policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect == "Allow"
    contains(out.Statement[ix].Action, "*")
    out.Statement[ix].Principal == "*"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Statement.Principal", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT *",
                "keyActualValue": 	"*"
              })
}

