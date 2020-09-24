package Cx

SupportedResources = "$.resource.aws_s3_bucket"

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_s3_bucket[name]
    resource.acl == "public-read"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].acl", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "private",
                "keyActualValue": 	"public-read",
                "value":            resource.bucket
              })
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_s3_bucket[name]
    resource.acl == "public-read-write"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].acl", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "private",
                "keyActualValue": 	"public-read-write",
                "value":            resource.bucket
              })
}

CxPolicy [ result ] {
    resource := input.document[i].resource.aws_s3_bucket[name]
    resource.acl == "website"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].acl", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "private",
                "keyActualValue": 	"website",
                "value":            resource.bucket
              })
}
