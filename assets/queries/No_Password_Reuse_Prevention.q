package Cx

#CxPragma "$.resource.aws_iam_account_password_policy"
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pol], "search": "aws_iam_account_password_policy"}) ] {
	pol := input.All[i].resource.aws_iam_account_password_policy[name]
    not pol.password_reuse_prevention    
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pol], "search": "aws_iam_account_password_policy"}) ] {
	pol := input.All[i].resource.aws_iam_account_password_policy[name]
    pol.password_reuse_prevention = false
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "No password reuse prevention",
        "severity": "Medium",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
