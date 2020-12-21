package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::SNS::Topic"
  properties := resource.Properties
  object.get(properties, "KmsMasterKeyId", "undefined") == "undefined"


	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.KmsMasterKeyId",[name]),
                "issueType":		"MissingAttribute",  
                "keyExpectedValue": sprintf("Resources.%s.Properties.KmsMasterKeyId is defined",[name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.KmsMasterKeyId is undefined",[name])
              }
}