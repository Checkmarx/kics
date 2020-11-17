package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_ebs_encryption_by_default[name]
  resource.enabled == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_ebs_encryption_by_default[%s].enabled", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'aws_ebs_encryption_by_default.encrypted' is true",
                "keyActualValue": "aws_ebs_encryption_by_default.encrypted' is false"
              }
}
