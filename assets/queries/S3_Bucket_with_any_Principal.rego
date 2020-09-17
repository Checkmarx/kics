package Cx

SupportedResources = "$.resource ? (@.aws_s3_bucket_policy != null || @.aws_s3_bucket != null)"

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    pol.Statement[idx].Principal = "*"

    result := {
                "foundKye": 		pol.Statement[idx],
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", [r, name]), "policy", "Principal+*"],
                "issueType":		"IncorrectValue",
                "keyName":			"policy",
                "keyExpectedValue": null,
                "keyActualValue": 	"*",
                #{metadata}
              }
}

CxPolicy [ result ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.document[i].resource[pl[r]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    contains(pol.Statement[idx].Principal.AWS, "*")

    result := {
                "foundKye": 		pol.Statement[idx],
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", [r, name]), "policy", "AWS"],
                "issueType":		"MissingAttribute",
                "keyName":			"policy",
                "keyExpectedValue": null,
                "keyActualValue": 	null,
                #{metadata}
              }
}
