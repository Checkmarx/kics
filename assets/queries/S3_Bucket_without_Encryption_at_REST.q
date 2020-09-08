package Cx

#CxPragma "$.resource.aws_s3_bucket"

#S3 bucket without encryption at REST
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

#default of block_public_policy is false
result [ getMetadata({"id" : input.All[i].CxId, "data" : [input.All[i].resource.aws_s3_bucket[name]], "search": "aws_s3_bucket"}) ] {
	not input.All[i].resource.aws_s3_bucket[name].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default 
}


getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 bucket without encryption at REST",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
