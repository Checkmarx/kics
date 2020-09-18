package Cx

SupportedResources = "$.resource.aws_cloudfront_distribution"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_cloudfront_distribution[name]
    resource.default_cache_behavior.viewer_protocol_policy = "allow-all"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "https-only",
                "keyActualValue": 	"allow-all"
              })
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_cloudfront_distribution[name]
    resource.ordered_cache_behavior.viewer_protocol_policy = "allow-all"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "https-only",
                "keyActualValue": 	"allow-all"
              })
}