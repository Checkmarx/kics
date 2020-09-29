package Cx

SupportedResources = "$.resource.aws_s3_bucket"

#default of block_public_policy is false
CxPolicy [ result ] {
    bucket := input.document[i].resource.aws_s3_bucket[name]
	not bucket.server_side_encryption_configuration.rule.apply_server_side_encryption_by_default

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].server_side_encryption_configuration.rule.apply_server_side_encryption_by_default", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "!null",
                "keyActualValue": 	null
              })
}
