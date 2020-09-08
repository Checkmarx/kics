package Cx


#CxPragma "$.resource ? (@.aws_iam_role_policy != null || @.aws_iam_user_policy != null  || @.aws_iam_group_policy != null  || @.aws_iam_policy_attachment != null)"

#IAM policies allow all ('*') in a statement action
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy


result [ getMetadata({"id" : input.All[i].CxId, "data" : [out], "search": [ "Resource"]}) ] {
	PolicyArr := {"aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy", "aws_iam_policy_attachment"}
    policy := input.All[i].resource[PolicyArr[idx]][name].policy
    out := json.unmarshal(policy)
    out.Statement[ix].Effect = "Allow"
    out.Statement[ix].Resource = "*"
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Allow all IAM policies",
        "severity": "Medium",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
