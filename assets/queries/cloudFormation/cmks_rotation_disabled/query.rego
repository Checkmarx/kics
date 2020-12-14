package Cx

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
    resource.Type == "AWS::KMS::Key"
    resource.Properties.Enabled == true
    object.get(resource.Properties, "EnableKeyRotation", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties",  [name]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' is defined", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.EnableKeyRotation' is not defined", [name]),
              }
}

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
    resource.Type == "AWS::KMS::Key"
    resource.Properties.Enabled == true
    resource.Properties.EnableKeyRotation == false

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.EnableKeyRotation",  [name]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'Resources.%s.Properties.EnableKeyRotation' is true", [name]),
                "keyActualValue": 	sprintf("'Resources.%s.Properties.EnableKeyRotation' is false", [name]),
              }
}