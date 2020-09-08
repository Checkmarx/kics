package Cx

#CxPragma "$.resource.aws_cloudfront_distribution"

#CloudFront Distribution without WAF enabled
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution

result [ getMetadata({"id" : input.All[i].CxId, "data" : [ res ], "search": ["aws_cloudfront_distribution"]}) ] {
	res := input.All[i].resource.aws_cloudfront_distribution[name]
    not res.web_acl_id
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Cloudfront without WAF",
        "severity": "Low",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}
