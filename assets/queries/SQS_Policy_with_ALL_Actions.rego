package Cx

SupportedResources = "$.resource.aws_sqs_queue_policy"

CxPolicy [ result ] {
    policy := input.document[i].resource.aws_sqs_queue_policy[name].policy
    out := json.unmarshal(policy)
    out.Statement[idx].Action = "*"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Action", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": null,
                "keyActualValue": 	"*"
              })
}
