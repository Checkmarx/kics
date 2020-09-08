package Cx

#CxPragma "$.resource.aws_s3_bucket"

#S3 bucket without versioning
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#versioning

#default of mfa_delete is false
result [ getMetadata({"id" : input.All[i].CxId, "data" : [b], "search": "aws_s3_bucket"}) ] {
	b := input.All[i].resource.aws_s3_bucket[name]
	not b.versioning
}


#default of enabled is false
result [ getMetadata({"id" : input.All[i].CxId, "data" : [b], "search": "aws_s3_bucket"}) ] {
	b := input.All[i].resource.aws_s3_bucket[name]
	not b.versioning.enabled
}


result [ getMetadata({"id" : input.All[i].CxId, "data" : [v], "search": "versioning"}) ] {
	v := input.All[i].resource.aws_s3_bucket[name].versioning	
    v.enabled != true
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 bucket without versioning",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
