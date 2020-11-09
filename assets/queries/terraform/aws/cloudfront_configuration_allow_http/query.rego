package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_cloudfront_distribution[name]
    resource.default_cache_behavior.viewer_protocol_policy = "allow-all"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'default_cache_behavior.viewer_protocol_policy' is equal 'https-only'",
                "keyActualValue": 	"'default_cache_behavior.viewer_protocol_policy' is equal 'allow-all'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_cloudfront_distribution[name]
    resource.ordered_cache_behavior.viewer_protocol_policy = "allow-all"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'ordered_cache_behavior.viewer_protocol_policy' is equal 'https-only'",
                "keyActualValue": 	"'ordered_cache_behavior.viewer_protocol_policy' is equal 'allow-all'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}