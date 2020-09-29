package Cx

SupportedResources = "$.resource.aws_sqs_queue_policy"

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_sqs_queue_policy[name]
    policy := resource.policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect == "Allow"
    contains(out.Statement[ix].Action, "*")
    aws := out.Statement[ix].Principal.AWS
    is_string(aws)
    contains(aws, "*")

    queue_name := trim_prefix(trim_suffix(resource.queue_url, ".id}"), "${aws_sqs_queue.")
    queue_resource := input.document[j].resource.aws_sqs_queue[queue_name]

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Statement.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT *",
                "keyActualValue":   aws,
                "value":            queue_resource.name
              })
}

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_sqs_queue_policy[name]
    policy := resource.policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect == "Allow"
    contains(out.Statement[ix].Action, "*")
    aws := out.Statement[ix].Principal.AWS
    is_array(aws)
    contains(aws[idx], "*")

    queue_name := trim_prefix(trim_suffix(resource.queue_url, ".id}"), "${aws_sqs_queue.")
    queue_resource := input.document[j].resource.aws_sqs_queue[queue_name]

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Statement.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT *",
                "keyActualValue":   aws[idx],
                "value":            queue_resource.name
              })
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_sqs_queue_policy[name]
	policy := resource.policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect == "Allow"
    contains(out.Statement[ix].Action, "*")
    out.Statement[ix].Principal == "*"

    queue_name := trim_prefix(trim_suffix(resource.queue_url, ".id}"), "${aws_sqs_queue.")
    queue_resource := input.document[j].resource.aws_sqs_queue[queue_name]

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Statement.Principal", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "NOT *",
                "keyActualValue": 	"*",
                "value":            queue_resource.name
              })
}

