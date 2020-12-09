package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_cloudfront_distribution[name]
  resource.default_cache_behavior.viewer_protocol_policy == "allow-all"
	
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("resource.aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy is 'https-only' or 'redirect-to-https'", [name]),
                "keyActualValue": 	sprintf("resource.aws_cloudfront_distribution[%s].default_cache_behavior.viewer_protocol_policy 'isn't https-only' or 'redirect-to-https'", [name])
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_cloudfront_distribution[name]
  resource.ordered_cache_behavior.viewer_protocol_policy == "allow-all"
    
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("resource.aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("resource.aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy is 'https-only' or 'redirect-to-https'", [name]),
                "keyActualValue": 	sprintf("resource.aws_cloudfront_distribution[%s].ordered_cache_behavior.viewer_protocol_policy 'isn't https-only' or 'redirect-to-https'", [name])
              }
}