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
                "keyExpectedValue": "'Resources.Properties.DistributionConfig.WebACLId' is defined",
                "keyActualValue": 	"'Resources.Properties.DistributionConfig.WebACLId' is undefined"
              }
}