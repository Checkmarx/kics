package Cx

CxPolicy [ result ] {
  resource := input.document[i]
  resource.Type == "AWS::SecretsManager::Secret"
  properties := resource.Properties
  object.get(properties, "KmsKeyId", "undefined") == "undefined"


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "Properties",
                "issueType":		"MissingValue",  
                "keyExpectedValue": "'Properties.KmsKeyId' is defined",
                "keyActualValue": 	"'Properties.KmsKeyId' is undefined"
              }
} 