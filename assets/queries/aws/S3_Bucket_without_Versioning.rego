package Cx

SupportedResources = "$.resource.aws_s3_bucket"

#default of mfa_delete is false
CxPolicy [ result ] {
	b := input.document[i].resource.aws_s3_bucket[name]
	not b.versioning

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s]", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": "!null",
                "keyActualValue": 	null
              })
}

#default of enabled is false
CxPolicy [ result ] {
	b := input.document[i].resource.aws_s3_bucket[name]
	object.get(b.versioning, "enabled", "not found") == "not found"

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].versioning", [name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": true,
                "keyActualValue": 	null
              })
}

CxPolicy [ result ] {
	v := input.document[i].resource.aws_s3_bucket[name].versioning
    v.enabled != true

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_s3_bucket[%s].versioning.enabled", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": true,
                "keyActualValue": 	v.enabled
              })
}
