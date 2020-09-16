package Cx

SupportedResources = "$.resource.aws_cloudfront_distribution"

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
    not resource.web_acl_id

    result := {
                "foundKye": 		resource,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_cloudfront_distribution", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"web_acl_id",
                "keyExpectedValue": null,
                "keyActualValue": 	null,
                #{metadata}
              }
}

