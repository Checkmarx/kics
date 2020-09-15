package Cx

#CxPragma "$.resource.aws_iam_account_password_policy"

#Unchangeble passwords in AWS password policty
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy
#allow_users_to_change_password default is true

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pol], "search": concat("+", ["aws_iam_account_password_policy", name]) }) ] {
	pol := input.All[i].resource.aws_iam_account_password_policy[name]
    pol.allow_users_to_change_password = false
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Unchangeable password",
        "severity": "Medium",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
