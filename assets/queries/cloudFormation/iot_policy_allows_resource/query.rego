package Cx

CxPolicy [ result ] {
   resources := input.document[i].Resources[name]
   resources.Type == "AWS::IoT::Policy"
   document := resources.Properties.PolicyDocument
   statements = document.Statement
   statements[k].Resource == "*"


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PolicyDocument.Statement.Effect=%s.Resource",[name,statements[k].Effect]),   
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement[%s].Resource is not '*'",[name,statements[k].Effect]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.PolicyDocument.Statement[%s].Recource is '*'",[name,statements[k].Effect]),
              }
}