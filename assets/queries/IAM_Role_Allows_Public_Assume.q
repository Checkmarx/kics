package Cx

#CxPragma "$.resource.aws_iam_role"

#IAM role allows All services or principals to assume it
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role


result [ getMetadata({"id" : input.All[i].CxId, "data" : [out], "search": ["assume_role_policy", "Principal", "*"]}) ] {
	policy := input.All[i].resource.aws_iam_role[name].assume_role_policy
    re_match("Service", policy)
    out := json.unmarshal(policy)
    not out.Statement[ix].Effect
    aws := out.Statement[ix].Principal.AWS
    contains(aws, "*")
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [out], "search": ["assume_role_policy", "Principal", "*"]}) ] {
	policy := input.All[i].resource.aws_iam_role[name].assume_role_policy
    re_match("Service", policy)
    out := json.unmarshal(policy)
    out.Statement[ix].Effect != "Deny"
    aws := out.Statement[ix].Principal.AWS
    contains(aws, "*")
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "IAM role allows public assume",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
