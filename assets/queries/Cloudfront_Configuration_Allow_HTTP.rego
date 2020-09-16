package Cx

SupportedResources = "$.resource.aws_cloudfront_distribution"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_cloudfront_distribution[name]
    resource.default_cache_behavior.viewer_protocol_policy = "allow-all"

    result := {
                "foundKye": 		resource.default_cache_behavior,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_cloudfront_distribution", name]), "default_cache_behavior", "viewer_protocol_policy"],
                "issueType":		"IncorrectValue",
                "keyName":			"viewer_protocol_policy",
                "keyExpectedValue": 8,
                "keyActualValue": 	"allow-all",
                #{metadata}
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_cloudfront_distribution[name]
    resource.ordered_cache_behavior.viewer_protocol_policy = "allow-all"

    result := {
                "foundKye": 		resource.ordered_cache_behavior,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_cloudfront_distribution", name]), "ordered_cache_behavior", "viewer_protocol_policy"],
                "issueType":		"IncorrectValue",
                "keyName":			"viewer_protocol_policy",
                "keyExpectedValue": 8,
                "keyActualValue": 	"allow-all",
                #{metadata}
              }
}