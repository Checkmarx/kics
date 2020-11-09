package Cx

CxPolicy [ result ] {
	resource := input.file[i].resource.aws_sqs_queue_policy[name]
    policy := resource.policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect == "Allow"
    contains(out.Statement[ix].Action, "*")
    aws := out.Statement[ix].Principal.AWS
    is_string(aws)
    contains(aws, "*")

    queue_name := trim_prefix(trim_suffix(resource.queue_url, ".id}"), "${aws_sqs_queue.")
    queue_resource := input.file[j].resource.aws_sqs_queue[queue_name]

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Statement.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Principal.AWS' is not equal '*'",
                "keyActualValue": 	"'policy.Statement.Principal.AWS' is equal '*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            queue_resource.name
              }
}

CxPolicy [ result ] {
	resource := input.file[i].resource.aws_sqs_queue_policy[name]
    policy := resource.policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect == "Allow"
    contains(out.Statement[ix].Action, "*")
    aws := out.Statement[ix].Principal.AWS
    is_array(aws)
    contains(aws[idx], "*")

    queue_name := trim_prefix(trim_suffix(resource.queue_url, ".id}"), "${aws_sqs_queue.")
    queue_resource := input.file[j].resource.aws_sqs_queue[queue_name]

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Statement.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Principal.AWS' is not equal '*'",
                "keyActualValue": 	"'policy.Statement.Principal.AWS' is equal '*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            queue_resource.name
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_sqs_queue_policy[name]
	policy := resource.policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect == "Allow"
    contains(out.Statement[ix].Action, "*")
    out.Statement[ix].Principal == "*"

    queue_name := trim_prefix(trim_suffix(resource.queue_url, ".id}"), "${aws_sqs_queue.")
    queue_resource := input.file[j].resource.aws_sqs_queue[queue_name]

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_sqs_queue_policy[%s].policy.Statement.Principal", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Principal' is not equal '*'",
                "keyActualValue": 	"'policy.Statement.Principal' is equal '*'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            queue_resource.name
              }
}

