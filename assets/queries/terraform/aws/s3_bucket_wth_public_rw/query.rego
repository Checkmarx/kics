package Cx

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_s3_bucket[name]
    resource.acl == "public-read"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].acl=public-read", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'acl' is equal 'private'",
                "keyActualValue": 	"'acl' is equal 'public-read'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            resource.bucket
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_s3_bucket[name]
    resource.acl == "public-read-write"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].acl=public-read-write", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'acl' is equal 'private'",
                "keyActualValue": 	"'acl' is equal 'public-read-write'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            resource.bucket
              }
}

CxPolicy [ result ] {
    resource := input.file[i].resource.aws_s3_bucket[name]
    resource.acl == "website"

    result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].acl=website", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'acl' is equal 'private'",
                "keyActualValue": 	"'acl' is equal 'website'",
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl,
                "value":            resource.bucket
              }
}
