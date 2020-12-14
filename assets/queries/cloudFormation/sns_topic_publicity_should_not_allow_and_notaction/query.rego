package Cx

CxPolicy [ result ] {
  resource := input.document[i].mysnspolicy
  resource.Type == "AWS::SNS::TopicPolicy"
  document := resource.Properties.PolicyDocument
  statements = document.Statement
  statements[k].Effect == "Allow"
  object.get(statements[k], "NotAction", "undefined") != "undefined"



	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Properties.PolicyDocument.Statement.Sid=%s",[statements[k].Sid]),   
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("Properties.PolicyDocument.Statement.Sid[%s] has Effect 'Allow' and Action",[statements[k].Sid]),
                "keyActualValue": 	sprintf("Properties.PolicyDocument.Statement.Sid[%s] has Effect 'Allow' and NotAction",[statements[k].Sid]),
              }
}