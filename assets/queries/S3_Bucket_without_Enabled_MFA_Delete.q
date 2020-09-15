package Cx

#CxPragma "$.resource.aws_s3_bucket"

#S3 bucket without enabled MFA Delete
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#mfa_delete

#default of mfa_delete is false
result [ getMetadata({"id" : input.All[i].CxId, "data" : [ver], "search": concat("+", ["aws_s3_bucket", name]) }) ] {
	ver := input.All[i].resource.aws_s3_bucket[name].versioning
    not ver.mfa_delete
}


result [ getMetadata({"id" : input.All[i].CxId, "data" : [ver], "search": concat("+", ["aws_s3_bucket", name]) }) ] {
	ver := input.All[i].resource.aws_s3_bucket[name].versioning
    ver.mfa_delete != true
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 bucket without enabled MFA Delete",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
