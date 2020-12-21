package Cx


CxPolicy [ result ]  { 

  document := input.document[i]
  resource := document.Resources[key]
  resource.Type == "AWS::EC2::Volume"

  properties := resource.Properties

  object.get(properties ,"KmsKeyId", "undefined") == "undefined" 

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.properties", [key]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.properties.KmsKeyId should be defined",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.KmsKeyId is undefined",[key])
              }
}
