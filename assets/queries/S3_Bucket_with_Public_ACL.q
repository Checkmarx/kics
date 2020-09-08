package Cx

#CxPragma "$.resource.aws_s3_bucket_public_access_block"

#S3 bucket allows public ACL
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block

#default of block_public_acls is false
result [ getMetadata({"id" : input.All[i].CxId, "data" : [pubACL], "search": "aws_s3_bucket_public_access_block"}) ] {
	pubACL := input.All[i].resource.aws_s3_bucket_public_access_block[name]
    not pubACL.block_public_acls
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pubACL], "search": "aws_s3_bucket_public_access_block"}) ] {
	pubACL := input.All[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.block_public_acls == false
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 bucket allows public ACL",
        "severity": "Medium",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
