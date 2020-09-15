package Cx

SupportedResources = "$.resource.aws_s3_bucket"

#default of block_public_policy is false
CxPolicy [ result ] {
    bucket := input.document[i].resource.aws_s3_bucket[name]
	not bucket.server_side_encryption_configuration.rule.apply_server_side_encryption_by_default

    result := {
                "foundKye": 		bucket,
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
