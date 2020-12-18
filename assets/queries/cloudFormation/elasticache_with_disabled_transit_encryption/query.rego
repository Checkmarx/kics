package Cx


CxPolicy [ result  ] { 

  document := input.document[i]
  resource := document.Resources[key]
  resource.Type = "AWS::ElastiCache::ReplicationGroup"
  properties := resource.Properties
  lower(properties.Engine) == "redis"
  properties.TransitEncryptionEnabled == false 
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.TransitEncryptionEnabled", [key]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("Resources.%s.Properties.TransitEncryptionEnabled should be true",[key]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.TransitEncryptionEnabled is false",[key])
              }
}


CxPolicy [ result ]  { 

  document := input.document[i]
  resource := document.Resources[key]
  properties := resource.Properties
  resource.Type = "AWS::ElastiCache::ReplicationGroup"
  lower(properties.Engine) == "redis"
  object.get(properties ,"TransitEncryptionEnabled", "undefined") == "undefined" 
  
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties", [key]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.Properties.TransitEncryptionEnabled should be defined",[key]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.TransitEncryptionEnabled is undefined",[key])
              }
}





