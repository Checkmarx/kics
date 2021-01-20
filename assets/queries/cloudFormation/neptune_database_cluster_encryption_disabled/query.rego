package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::Neptune::DBCluster"
  properties := resource.Properties
  properties.StorageEncrypted == false


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.StorageEncrypted",[name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("Resources.%s.Properties.StorageEncrypted is True",[name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.StorageEncrypted is False",[name])
              }
}