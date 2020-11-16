package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource
  resource.aws_cloudwatch_log_group
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "aws_cloudwatch_log_group",
                "issueType":		"IncorrectValue",
                "keyExpectedValue":  "'aws_cloudwatch_log_group' is set",
                "keyActualValue": 	"'aws_cloudwatch_log_group' is undefined"
              }
}

