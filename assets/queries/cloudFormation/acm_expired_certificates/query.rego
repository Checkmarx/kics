package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Status == "EXPIRED"

	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("Resources.%s.Status", [name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Status isnt 'EXPIRED'", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Status is 'EXPIRED'", [name])
              }
}