package Cx

SupportedResources = "$.resource.aws_s3_bucket"

CxPolicy [ result ] {
    acl := input.document[i].resource.aws_s3_bucket[name].acl
    acl == "public-read"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_s3_bucket[%s].acl", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "private",
                "keyActualValue": 	"public-read"
              })
}

CxPolicy [ result ] {
    acl := input.document[i].resource.aws_s3_bucket[name].acl
    acl == "public-read-write"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_s3_bucket[%s].acl", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "private",
                "keyActualValue": 	"public-read-write"
              })
}

CxPolicy [ result ] {
    acl := input.document[i].resource.aws_s3_bucket[name].acl
    acl == "website"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_s3_bucket[%s].acl", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "private",
                "keyActualValue": 	"website"
              })
}
