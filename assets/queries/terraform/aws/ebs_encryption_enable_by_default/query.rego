package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_ebs_encryption_by_default[name]
  resource.enabled == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_ebs_encryption_by_default[%s].enabled", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "One of 'aws_ebs_encryption_by_default.encrypted' is 'true'",
                "keyActualValue": 	"One of 'aws_ebs_encryption_by_default.encrypted' is 'false'"
              }
}
