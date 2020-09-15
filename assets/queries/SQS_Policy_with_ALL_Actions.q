package Cx

#CxPragma "$.resource.aws_sqs_queue_policy"

#SQS policy allows ALL (*) actions
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy


result [ getMetadata({"id" : input.All[i].CxId, "data" : [out], "search": concat("+", ["aws_sqs_queue_policy", name]) }) ] {
	policy := input.All[i].resource.aws_sqs_queue_policy[name].policy
    out := json.unmarshal(policy)
    out.Statement[idx].Action = "*"
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "SQS policy allows ALL (*) actions",
        "severity": "Medium",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
