package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.aws_cloudwatch_log_group[name]
  
  not resource.retention_in_days
  
  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("cloudwatch_log_group[%s]", [name]),
                "issueType":		      "MissingAttribute",
                "keyExpectedValue":   "Attribute 'retention_in_days' is set and equal 0",
                "keyActualValue": 	  "Attribute 'retention_in_days' is undefined"
            }
}




CxPolicy [ result ] {
  resource := input.document[i].resource.aws_cloudwatch_log_group[name]
  
  resource.retention_in_days != 0
  
  result := {
                "documentId": 		    input.document[i].id,
                "searchKey": 	        sprintf("cloudwatch_log_group[%s].retention_in_days", [name]),
                "issueType":		      "IncorrectValue",
                "keyExpectedValue":   "Attribute 'retention_in_days' is set and equal 0",
                "keyActualValue": 	  "Attribute 'retention_in_days' is set but not equal 0"
            }
}