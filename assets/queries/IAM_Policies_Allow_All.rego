package Cx

SupportedResources = "$.resource ? (@.aws_iam_role_policy != null || @.aws_iam_user_policy != null  || @.aws_iam_group_policy != null  || @.aws_iam_policy_attachment != null)"

CxPolicy [ result ] {
	PolicyArr := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy_attachment"}
    policy := input.document[i].resource[PolicyArr[idx]][name].policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect = "Allow"
    out.Statement[ix].Resource = "*"

    result := {
                "foundKye": 		out,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", [PolicyArr[idx], name]), "Resource"],
                "issueType":		"IncorrectValue",
                "keyName":			"policy",
                "keyExpectedValue": null,
                "keyActualValue": 	"*",
                #{metadata}
              }
}