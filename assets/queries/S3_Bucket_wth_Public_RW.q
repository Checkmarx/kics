package Cx

#CxPragma "$.resource.aws_s3_bucket"

#S3 bucket with public READ/WRITE access
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#mfa_delete


result [ getMetadata({"id" : input.All[i].CxId, "data" : [acl], "search": "aws_s3_bucket"}) ] {
	acl := input.All[i].resource.aws_s3_bucket[name].acl
    acl == "public-read"
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [acl], "search": "aws_s3_bucket"}) ] {
	acl := input.All[i].resource.aws_s3_bucket[name].acl
    acl == "public-read-write"
}


result [ getMetadata({"id" : input.All[i].CxId, "data" : [acl], "search": "aws_s3_bucket"}) ] {
	acl := input.All[i].resource.aws_s3_bucket[name].acl
    acl == "website"
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 bucket with public RW access",
        "severity": "Info",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
