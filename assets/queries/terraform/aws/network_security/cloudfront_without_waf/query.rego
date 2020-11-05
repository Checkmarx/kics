package Cx

CxPolicy [ result ] {
	resource := input.document[i].resource.aws_cloudfront_distribution[name]
    not resource.web_acl_id

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudfront_distribution[%s].web_acl_id", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'web_acl_id' exists",
                "keyActualValue": 	"'web_acl_id' is missing"
              }
}

