package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_s3_bucket[name]
    policy := resource.policy
    validate_json(policy)
    out := json.unmarshal(policy)
    out.Statement[ix].Effect = "Allow"
    action := out.Statement[ix].Action

    is_string(action)
    contains(action, "*")

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].policy.Statement.Action", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
                "keyActualValue": 	"'policy.Statement.Action' contain '*'",
                "value":            resource.bucket
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_s3_bucket[name]
    policy := resource.policy
    validate_json(policy)
    out := json.unmarshal(policy)
    out.Statement[ix].Effect = "Allow"
    action := out.Statement[ix].Action

    is_array(action)
    contains(action[_], "*")

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].policy.Statement.Action", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
                "keyActualValue": 	"'policy.Statement.Action' contain '*'",
                "value":            resource.bucket
              }
}

validate_json(string) = true {
	not startswith(string, "$")
}