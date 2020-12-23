package Cx

CxPolicy [ result ] {
	  resource := input.document[i].Resources[name]
    resource.Type == "AWS::SQS::QueuePolicy"

    statement := resource.Properties.PolicyDocument.Statement
    
    statement[index].Effect == "Allow"
    object.get(statement[index], "NotAction", "undefined") != "undefined"


    result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("Resources.%s.Properties.PolicyDocument.Statement.NotAction", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement[%d].NotAction is undefined while Resources.%s.Properties.PolicyDocument.Statement[%d].Effect=Allow", [name, index, name, index]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.PolicyDocument.Statement[%d].NotAction is set while Resources.%s.Properties.PolicyDocument.Statement[%d].Effect=Allow", [name, index, name, index])
              }
}