package Cx


#CxPragma "$.resource.aws_cloudfront_distribution"
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#viewer_protocol_policy

#Cloudfront distribution allows HTTP, it should be https-only or redirect-to-https

result [ getMetadata({"id" : input.All[i].CxId, "data" : [input.All[i].resource.aws_cloudfront_distribution[name].default_cache_behavior], "search": ["default_cache_behavior", "viewer_protocol_policy"]}) ] {
	input.All[i].resource.aws_cloudfront_distribution[name].default_cache_behavior.viewer_protocol_policy = "allow-all"
}

result [ getMetadata({"id" : input.All[i].CxId, "data" : [input.All[i].resource.aws_cloudfront_distribution[name].ordered_cache_behavior], "search": ["ordered_cache_behavior", "viewer_protocol_policy"]}) ] {
	input.All[i].resource.aws_cloudfront_distribution[name].ordered_cache_behavior.viewer_protocol_policy = "allow-all"
}

getMetadata(id) = res {
	some cnt
    input.All[cnt].CxId = id.id
    res := {
        "id" : input.All[cnt].CxId,
        "file" : input.All[cnt].CxFile,
        "name" : "Cloudfront configuration allow HTTP",
        "severity": "High",
        "cnt" : cnt,
        "search": id.search,
        "data" : id.data
    }
}

