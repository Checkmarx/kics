package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_cloudtrail[name]
  resource.enable_logging == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_cloudtrail.%s.enable_logging", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "enable_logging is true",
                "keyActualValue": 	"enable_logging is false"
              }
}