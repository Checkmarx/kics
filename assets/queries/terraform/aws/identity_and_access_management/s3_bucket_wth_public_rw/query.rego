package Cx

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_s3_bucket[name]
    resource.acl == "public-read"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].acl=public-read", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'acl' is equal 'private'",
                "keyActualValue": 	"'acl' is equal 'public-read'",
                "value":            resource.bucket
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_s3_bucket[name]
    resource.acl == "public-read-write"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].acl=public-read-write", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'acl' is equal 'private'",
                "keyActualValue": 	"'acl' is equal 'public-read-write'",
                "value":            resource.bucket
              }
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_s3_bucket[name]
    resource.acl == "website"

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].acl=website", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'acl' is equal 'private'",
                "keyActualValue": 	"'acl' is equal 'website'",
                "value":            resource.bucket
              }
}
