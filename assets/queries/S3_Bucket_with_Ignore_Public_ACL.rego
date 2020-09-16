package Cx

SupportedResources = "$.resource.aws_s3_bucket_public_access_block"

CxPolicy [ result ] {
    pubACL := input.document[i].resource.aws_s3_bucket_public_access_block[name]
    pubACL.ignore_public_acls == true

    result := {
                "foundKye": 		pubACL,
                "fileId": 			input.document[i].id,
                "fileName": 	    input.document[i].file,
                "lineSearchKey": 	[concat("+", ["aws_s3_bucket_public_access_block", name]), "ignore_public_acls"],
                "issueType":		"IncorrectValue",
                "keyName":			"ignore_public_acls",
                "keyExpectedValue": false,
                "keyActualValue": 	true,
                #{metadata}
              }
}
