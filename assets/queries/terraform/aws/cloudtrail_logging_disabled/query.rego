package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_cloudtrail[name]
  resource.enable_logging == false

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("aws_cloudtrail.%s.enable_logging", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("aws_cloudtrail.%s.enable_logging is true", [name]),
                "keyActualValue": 	sprintf("aws_cloudtrail.%s.enable_logging is false", [name])
              }
}
