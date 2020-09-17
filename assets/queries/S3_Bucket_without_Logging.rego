package Cx

SupportedResources = "$.resource.aws_s3_bucket"

CxPolicy [ result ] {
    s3 := input.document[i].resource.aws_s3_bucket[name]
	not s3.logging

    result := {
                "foundKye": 		s3,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	concat("+", ["aws_s3_bucket", name]),
                "issueType":		"MissingAttribute",
                "keyName":			"logging",
                "keyExpectedValue": null,
                "keyActualValue": 	null,
                #{metadata}
              }
}
