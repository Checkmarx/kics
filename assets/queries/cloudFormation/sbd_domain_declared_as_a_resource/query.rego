package Cx

CxPolicy [ result ] {
  document := input.document
  resource = document[i].Resources[name]
  resource.Type == "AWS::SDB::Domain"
  
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s is not defined", [name]),
                "keyActualValue": 	sprintf("Resources.%s is defined", [name])
              }
}