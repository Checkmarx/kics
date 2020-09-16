package Cx

SupportedResources = "$.resource.aws_s3_bucket"

#default of mfa_delete is false
CxPolicy [ result ] {
	b := input.document[i].resource.aws_s3_bucket[name]
	not b.versioning

    result := {
                "foundKye": 		b,
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

#default of enabled is false
CxPolicy [ result ] {
	b := input.document[i].resource.aws_s3_bucket[name]
	object.get(b.versioning, "enabled", "not found") == "not found"

    result := {
                "foundKye": 		b,
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
	v := input.document[i].resource.aws_s3_bucket[name].versioning
    v.enabled != true

    result := {
                "foundKye": 		v,
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
