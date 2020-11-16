package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_ebs_volume[name]
  not resource.encrypted


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_ebs_volume[%s].encrypted", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "One of 'aws_ebs_volume.encrypted' is 'true'",
                "keyActualValue": 	"One of 'aws_ebs_volume.encrypted' is 'false'"
              }
}