package Cx

SupportedResources = "$.resource ? (@.aws_iam_role_policy != null || @.aws_iam_user_policy != null  || @.aws_iam_group_policy != null  || @.aws_iam_policy_attachment != null)"

CxPolicy [ result ] {
    resourceType := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy_attachment"}
    policy := input.document[i].resource[resourceType[idx]][name].policy
    out := json.unmarshal(policy)
    out.Statement[ix].Resource = "*"
	out.Statement[ix].Effect = "Allow"
    out.Statement[ix].Action = ["*"]

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("%s[%s].policy.Action", [resourceType[idx], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": null,
                "keyActualValue": 	null
              })
}
