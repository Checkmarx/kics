package Cx

SupportedResources = "$.resource.aws_s3_bucket"

#default of mfa_delete is false
CxPolicy [ result ] {
    ver := input.document[i].resource.aws_s3_bucket[name].versioning
    not ver.mfa_delete

    result := {
                "foundKye": 		ver,
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
    ver := input.document[i].resource.aws_s3_bucket[name].versioning
    ver.mfa_delete != true

    result := {
                "foundKye": 		ver,
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
