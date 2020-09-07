package Cx


#CxPragma "$.resource ? (@.aws_s3_bucket_policy != null || @.aws_s3_bucket != null)"

#S3 bucket allows actions with any Principal
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pol.Statement[idx]], "search": "*"}) ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.All[i].resource[pl[_]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    pol.Statement[idx].Principal = "*"
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pol.Statement[idx]], "search": "*"}) ] {
	pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	policy := input.All[i].resource[pl[_]][name].policy
    pol := json.unmarshal(policy)
    pol.Statement[idx].Effect = "Allow"
    contains(pol.Statement[idx].Principal.AWS, "*")
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 bucket with any principal",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}