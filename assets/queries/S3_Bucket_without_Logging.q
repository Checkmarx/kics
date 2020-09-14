package Cx

#CxPragma "$.resource.aws_s3_bucket"

#S3 bucket without logging
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

result [ getMetadata({"id" : input.All[i].CxId, "data" : [s3], "search": concat("+", ["aws_s3_bucket", name])}) ] {
	s3 := input.All[i].resource.aws_s3_bucket[name]
	not s3.logging
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "S3 no logging",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
