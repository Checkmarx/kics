package Cx

CxPolicy [ result ] {
   resources := input.document[i].Resources[name]
   resources.Type == "AWS::KMS::Key"
   keyRotation := resources.Properties.EnableKeyRotation
   keyRotation == false

   
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.EnableKeyRotation",[name]),   
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("Resources.%s.Properties.EnableKeyRotation is not 'true'",[name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.EnableKeyRotation is true",[name]),
              }
}

CxPolicy [ result ] {
   resources := input.document[i].Resources[name]
   resources.Type == "AWS::KMS::Key"
   properties := resources.Properties
   object.get(properties, "EnableKeyRotation", "undefined") == "undefined"
   

   
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.EnableKeyRotation",[name]),   
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("Resources.%s.Properties.EnableKeyRotation is defined",[name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.EnableKeyRotation is undefined",[name]),
              }
}
