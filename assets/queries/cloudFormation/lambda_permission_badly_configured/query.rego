package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::Lambda::Permission"
  resource.Properties.Action != "lambda:InvokeFunction"

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("Resources.%s.Properties.Action", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("'Resources.%s.Properties.Action' is lambda:InvokeFunction ", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.Action' is not lambda:InvokeFunction", [name])
              }
}
