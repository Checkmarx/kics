package Cx

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
  resource.Type == "AWS::RDS::DBInstance"
  object.get(resource.Properties, "PubliclyAccessible", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties",  [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' is defined", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.PubliclyAccessible' is undefined", [name]),
              }
}

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
  resource.Type == "AWS::RDS::DBInstance"
  resource.Properties.PubliclyAccessible == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PubliclyAccessible",  [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.PubliclyAccessible' is false", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.PubliclyAccessible' is true", [name]),
              }
}