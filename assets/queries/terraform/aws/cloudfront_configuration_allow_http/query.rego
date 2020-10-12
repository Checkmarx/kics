package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_cloudfront_distribution[name]
    resource.default_cache_behavior.viewer_protocol_policy = "allow-all"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'default_cache_behavior.viewer_protocol_policy' is equal 'https-only'",
                "keyActualValue": 	"'default_cache_behavior.viewer_protocol_policy' is equal 'allow-all'"
              })
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_cloudfront_distribution[name]
    resource.ordered_cache_behavior.viewer_protocol_policy = "allow-all"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'ordered_cache_behavior.viewer_protocol_policy' is equal 'https-only'",
                "keyActualValue": 	"'ordered_cache_behavior.viewer_protocol_policy' is equal 'allow-all'"
              })
}