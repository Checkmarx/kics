package Cx

#CxPragma "$.resource.aws_s3_bucket_public_access_block"

#S3 bucket allows public policy
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block

#default of block_public_policy is false
result [ getMetadata({"id" : input.All[i].CxId, "data" : [pubACL], "search": concat("+", ["aws_s3_bucket_public_access_block", name]) }) ] {
	pubACL := input.All[i].resource.aws_s3_bucket_public_access_block[name]
    not pubACL.block_public_policy
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pubACL], "search": concat("+", ["aws_s3_bucket_public_access_block", name]) }) ] {
	pubACL := input.All[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.block_public_policy == false
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 bucket allows public policy",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
