package Cx

SupportedResources = "$.resource.aws_iam_role"

CxPolicy [ result ] {
	policy := input.document[i].resource.aws_iam_role[name].assume_role_policy
    re_match("arn:aws:iam::", policy)
    out := json.unmarshal(policy)
    aws := out.Statement[idx].Principal.AWS
    contains(aws, "arn:aws:iam::")
    contains(aws, ":root")

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": null,
                "keyActualValue": 	null
              })
}
