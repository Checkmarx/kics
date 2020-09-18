package Cx

SupportedResources = "$.resource.aws_s3_bucket_public_access_block"

#default of block_public_policy is false
CxPolicy [ result ] {
    pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
    object.get(pubACL, "block_public_policy", "not found") == "not found"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_s3_bucket_public_access_block[%s].block_public_policy", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": true,
                "keyActualValue": 	null
              })
}

CxPolicy [ result ] {
    pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.block_public_policy == false

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_s3_bucket_public_access_block[%s].block_public_policy", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": true,
                "keyActualValue": 	false
              })
}
