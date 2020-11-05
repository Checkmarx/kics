package Cx

CxPolicy [ result ] {
    resourceType := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy_attachment"}
    policy := input.document[i].resource[resourceType[idx]][name].policy
    out := json.unmarshal(policy)
    out.Statement[ix].Resource = "*"
	out.Statement[ix].Effect = "Allow"
    out.Statement[ix].Action = ["*"]

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s[%s].policy.Action", [resourceType[idx], name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'policy.Statement.Action' doesn't contain '*'",
                "keyActualValue": 	"'policy.Statement.Action' contains '*'"
              }
}
