package Cx

SupportedResources = "$.resource.aws_s3_bucket_public_access_block"

#default of restrict_public_buckets is false
CxPolicy [ result ] {
    pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
    not pubACL.restrict_public_buckets

    result := {
                "foundKye": 		pubACL,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_s3_bucket_public_access_block", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}

CxPolicy [ result ] {
    pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.restrict_public_buckets == false

    result := {
                "foundKye": 		pubACL,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_s3_bucket_public_access_block", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"protocol",
                "keyExpectedValue": 8,
                "keyActualValue": 	null,
                #{metadata}
              }
}
