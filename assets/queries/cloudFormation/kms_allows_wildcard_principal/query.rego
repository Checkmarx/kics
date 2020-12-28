package Cx

CxPolicy [ result ] {
   resources := input.document[i].Resources[name]
   resources.Type == "AWS::KMS::Key"
   document := resources.Properties.KeyPolicy
   statements = document.Statement
   statements[k].Principal == "*"

   
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.KeyPolicy.Statement.Sid=%s.Principal",[name,statements[k].Sid]),   
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Sid[%s].Principal is not '*'",[name,statements[k].Sid]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.PolicyDocument.Statement.Sid[%s].Principal is '*'",[name,statements[k].Sid]),
              }
}
