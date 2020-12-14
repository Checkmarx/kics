package Cx

CxPolicy [ result ] {
  resource := input.document[i]
  resource.Type == "AWS::SNS::Topic"
  properties := resource.Properties
  object.get(properties, "KmsMasterKeyId", "undefined") == "undefined"


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "Properties.KmsMasterKeyId",
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": "Properties.KmsMasterKeyId' is defined",
                "keyActualValue": 	"Properties.KmsMasterKeyId' is undefined"
              }
}