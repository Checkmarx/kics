package Cx

CxPolicy [ result ] {
	resource := input.file[i].resource.aws_cloudfront_distribution[name]
    not resource.web_acl_id

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_cloudfront_distribution[%s].web_acl_id", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "'web_acl_id' exists",
                "keyActualValue": 	"'web_acl_id' is missing",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

