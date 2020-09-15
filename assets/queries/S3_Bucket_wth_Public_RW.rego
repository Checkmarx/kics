package Cx

SupportedResources = "$.resource.aws_s3_bucket"

CxPolicy [ result ] {
    acl := input.document[i].resource.aws_s3_bucket[name].acl
    acl == "public-read"

    result := {
                "foundKye": 		acl,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_s3_bucket", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}

CxPolicy [ result ] {
    acl := input.document[i].resource.aws_s3_bucket[name].acl
    acl == "public-read-write"

    result := {
                "foundKye": 		acl,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_s3_bucket", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}

CxPolicy [ result ] {
    acl := input.document[i].resource.aws_s3_bucket[name].acl
    acl == "website"

    result := {
                "foundKye": 		acl,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_s3_bucket", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}
