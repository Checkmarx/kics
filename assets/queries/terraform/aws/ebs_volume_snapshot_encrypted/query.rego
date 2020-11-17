package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_ebs_snapshot[name]
  not resource.encrypted

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_ebs_snapshot[%s].encrypted", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "One of 'aws_ebs_snapshot.encrypted' is 'true'",
                "keyActualValue": 	"One of 'aws_ebs_snapshot.encrypted' is 'false'"
              }
}