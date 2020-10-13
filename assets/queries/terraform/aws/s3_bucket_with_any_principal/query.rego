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
                "keyExpectedValue": "NOT *",
                "keyActualValue": 	"*"
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
                "keyExpectedValue": "NOT *",
                "keyActualValue": 	pol.Statement[idx].Principal.AWS
              })
}
