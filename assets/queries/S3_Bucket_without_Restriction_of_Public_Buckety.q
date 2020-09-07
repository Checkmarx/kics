package Cx

#CxPragma "$.resource.aws_s3_bucket_public_access_block"

#S3 bucket without restriction of public bucket
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block

#default of restrict_public_buckets is false
result [ getMetadata({"id" : input.All[i].CxId, "data" : [pubACL], "search": "aws_s3_bucket_public_access_block"}) ] {
	pubACL := input.All[i].resource.aws_s3_bucket_public_access_block[name]
    not pubACL.restrict_public_buckets
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [pubACL], "search": "aws_s3_bucket_public_access_block"}) ] {
	pubACL := input.All[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.restrict_public_buckets == false
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 bucket without restriction of public buckety",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
