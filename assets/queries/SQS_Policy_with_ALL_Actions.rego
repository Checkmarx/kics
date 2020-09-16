package Cx

SupportedResources = "$.resource.aws_sqs_queue_policy"

CxPolicy [ result ] {
    policy := input.document[i].resource.aws_sqs_queue_policy[name].policy
    out := json.unmarshal(policy)
    out.Statement[idx].Action = "*"

    result := {
                "foundKye": 		out,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_sqs_queue_policy", name]),
                "issueType":		"IncorrectValue",
                "keyName":			"policy",
                "keyExpectedValue": null,
                "keyActualValue": 	"*",
                #{metadata}
              }
}
