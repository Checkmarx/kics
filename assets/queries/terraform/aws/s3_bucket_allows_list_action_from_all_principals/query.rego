package Cx

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    pol.Statement[idx].Principal = "*"
	contains(lower(pol.Statement[idx].Action), "list")

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Action", [pl[r], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s[%s].policy.Action is not a 'List' action", [pl[r], name]),
                "keyActualValue": 	sprintf("%s[%s].policy.Action is a 'List' action", [pl[r], name])
              }
}

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    contains(pol.Statement[idx].Principal.AWS, "*")
	contains(lower(pol.Statement[idx].Action), "list")

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Action", [pl[r], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s[%s].policy.Action is not a 'List' action", [pl[r], name]),
                "keyActualValue": 	sprintf("%s[%s].policy.Action is a 'List' action", [pl[r], name])
              }
}