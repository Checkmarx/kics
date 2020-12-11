package Cx

CxPolicy [ result ] {
  resource := input.document[i]
  resource.Type == "AWS::Neptune::DBCluster"
  properties := resource.Properties
  properties.StorageEncrypted == false


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "Properties.StorageEncrypted",
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": "'Properties.StorageEncrypted' is True",
                "keyActualValue": 	"'Properties.StorageEncrypted' is False"
              }
}