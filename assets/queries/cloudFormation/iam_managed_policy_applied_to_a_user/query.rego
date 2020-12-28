package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[Name]
  resource.Type == "AWS::IAM::ManagedPolicy"
  count(resource.Properties.Users) > 0
  
result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.Users", [Name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("Resources.%s is assigned to a set of users", [Name]),
                "keyActualValue": 	sprintf("Resources.%s should be assigned to a set of groups", [Name])
              }
}

