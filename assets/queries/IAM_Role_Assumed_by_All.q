package Cx

#CxPragma "$.resource.aws_iam_role"

#IAM role allows all services or principals to assume it
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

result [ getMetadata({"id" : input.All[i].CxId, "data" : [aws], "search": concat("+", ["aws_iam_role", name])}) ] {
	policy := input.All[i].resource.aws_iam_role[name].assume_role_policy
    re_match("arn:aws:iam::", policy)
    out := json.unmarshal(policy)
    aws := out.Statement[idx].Principal.AWS
    contains(aws, "arn:aws:iam::")
    contains(aws, ":root")
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "IAM role allows all principals to assume",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
