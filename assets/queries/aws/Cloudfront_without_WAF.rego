package Cx

SupportedResources = "$.resource.aws_cloudfront_distribution"

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
    not resource.web_acl_id

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudfront_distribution[%s].web_acl_id", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "!null",
                "keyActualValue": 	"null"
              })
}

