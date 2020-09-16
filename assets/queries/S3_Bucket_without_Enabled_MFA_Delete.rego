package Cx

SupportedResources = "$.resource.aws_s3_bucket"

#default of mfa_delete is false
CxPolicy [ result ] {
    ver := input.document[i].resource.aws_s3_bucket[name].versioning
    object.get(ver, "mfa_delete", "not found") == "not found"

    result := {
                "foundKye": 		ver,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_s3_bucket", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"versioning.mfa_delete",
                "keyExpectedValue": true,
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
                "issueType":		"IncorrectValue",
                "keyName":			"versioning.mfa_delete",
                "keyExpectedValue": true,
                "keyActualValue": 	ver.mfa_delete,
                #{metadata}
              }
}
