package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::CloudTrail::Trail"
  checkFileValidation(resource)

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [name]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("'Resources.%s.Properties.EnableLogFileValidation' should be true", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.EnableLogFileValidation' is not true", [name])
              }
}

checkFileValidation(cltr) {
	object.get(cltr.Properties , "EnableLogFileValidation", "not found") == "not found"
}

checkFileValidation(cltr) {
	object.get(cltr.Properties , "EnableLogFileValidation", "not found") == false
}

