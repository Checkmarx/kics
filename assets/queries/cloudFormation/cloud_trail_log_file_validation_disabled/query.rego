package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::CloudTrail::Trail"
  object.get(resource.Properties , "EnableLogFileValidation", "not found") == "not found"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [name]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties.EnableLogFileValidation' exists", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.EnableLogFileValidation' is missing", [name])
              }
}

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::CloudTrail::Trail"
  object.get(resource.Properties , "EnableLogFileValidation", "not found") == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.EnableLogFileValidation", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties.EnableLogFileValidation' is true", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.EnableLogFileValidation' is not true", [name])
              }
}

