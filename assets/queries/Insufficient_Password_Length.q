package Cx

#CxPragma "$.resource.aws_iam_account_password_policy"

#Unsafe Password length policy
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pol], "search": concat("+", ["aws_iam_account_password_policy", name]) }) ] {
	pol := input.All[i].resource.aws_iam_account_password_policy[name]
    not pol.minimum_password_length    
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pol], "search":  concat("+", ["aws_iam_account_password_policy", name]) }) ] {
	pol := input.All[i].resource.aws_iam_account_password_policy[name]
    pol.minimum_password_length < 8
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Insufficient password length",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}