package Cx


CxPolicy [ result  ] { 

  document := input.document[i]
  resource := document.Resources[key]
  
  properties := resource.Properties
  lower(properties.Engine) == "redis"
  properties.TransitEncryptionEnabled == false 
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.properties", [key]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("Resources.%s.properties.TransitEncryptionEnabled should be true",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.TransitEncryptionEnabled is false",[key])
              }
}


CxPolicy [ result ]  { 

  document := input.document[i]
  resource := document.Resources[key]
  properties := resource.Properties
  lower(properties.Engine) == "redis"
  object.get(properties ,"TransitEncryptionEnabled", "undefined") == "undefined" 
  
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.properties", [key]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.properties.TransitEncryptionEnabled should be defined",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.TransitEncryptionEnabled is undefined",[key])
              }
}





