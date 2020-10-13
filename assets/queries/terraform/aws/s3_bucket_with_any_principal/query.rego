package Cx

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    pol.Statement[idx].Principal = "*"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Principal", [pl[r], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Principal' is not equal '*'",
                "keyActualValue": 	"'policy.Statement.Principal' is equal '*'"
              })
}

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    contains(pol.Statement[idx].Principal.AWS, "*")

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Principal.AWS", [pl[r], name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'policy.Statement.Principal.AWS' doesn't contain '*'",
                "keyActualValue": 	"'policy.Statement.Principal.AWS' contains '*'"
              })
}
