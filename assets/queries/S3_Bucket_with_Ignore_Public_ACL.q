package Cx

#CxPragma "$.resource.aws_s3_bucket_public_access_block"

#S3 bucket with ignore public ACL
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block



result [ getMetadata({"id" : input.All[i].CxId, "data" : [pubACL], "search": concat("+", ["aws_s3_bucket_public_access_block", name]) }) ] {
	pubACL := input.All[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.ignore_public_acls == true
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 bucket with ignore public ACL",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
