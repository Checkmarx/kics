package Cx

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    pol.Statement[idx].Principal = "*"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Principal", [pl[r], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s[%s].policy.Principal is not equal to '*'", [pl[r], name]),
                "keyActualValue": 	sprintf("%s[%s].policy.Principal is equal to '*'", [pl[r], name])
              }
}

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    contains(pol.Statement[idx].Principal.AWS, "*")

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Principal.AWS", [pl[r], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s[%s].policy.Principal.AWS doesn't contain '*'", [pl[r], name]),
                "keyActualValue": 	sprintf("%s[%s].policy.Principal.AWS contains '*'", [pl[r], name])
              }
}
