package Cx


#CxPragma "$.resource.aws_ecr_repository_policy"

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pol], "search": "Principal"}) ] {
	some i
    pol := input.All[i].resource.aws_ecr_repository_policy[_].policy
    re_match("\"Principal\"\\s*:\\s*\"*\"", pol)
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Public ECR policy",
        "severity": "Medium",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
