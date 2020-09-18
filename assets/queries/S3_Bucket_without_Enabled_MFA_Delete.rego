package Cx

SupportedResources = "$.resource.aws_s3_bucket"

#default of mfa_delete is false
CxPolicy [ result ] {
    ver := input.document[i].resource.aws_s3_bucket[name].versioning
    object.get(ver, "mfa_delete", "not found") == "not found"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_s3_bucket[%s].versioning.mfa_delete", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": true,
                "keyActualValue": 	null
              })
}

CxPolicy [ result ] {
    ver := input.document[i].resource.aws_s3_bucket[name].versioning
    ver.mfa_delete != true

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "lineSearchKey": 	sprintf("aws_s3_bucket[%s].versioning.mfa_delete", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": true,
                "keyActualValue": 	ver.mfa_delete
              })
}
