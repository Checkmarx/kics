package Cx

#CxPragma "$.resource.aws_iam_policy_attachment"

#IAM policies should be attached only to groups or roles
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment


result [ getMetadata({"id" : input.All[i].CxId, "data" : [input.All[i].resource.aws_iam_policy_attachment[_]], "search": concat("+", ["aws_iam_policy_attachment", name])}) ] {
	input.All[i].resource.aws_iam_policy_attachment[name].user
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "IAM policies attached to user",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
