package Cx

#CxPragma "$.resource.aws_iam_account_password_policy"

#No password exeration policy
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy

result [ getMetadata({"id" : input.All[i].CxId, "data" : [expr], "search": concat("+", ["aws_iam_account_password_policy", name]) }) ] {
	expr := input.All[i].resource.aws_iam_account_password_policy[name]
    not expr.max_password_age
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [expr], "search": concat("+", ["aws_iam_account_password_policy", name]) }) ] {
	expr := input.All[i].resource.aws_iam_account_password_policy[name]
    expr.max_password_age > 90
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Incorrect password policy expiration",
        "severity": "Medium",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
