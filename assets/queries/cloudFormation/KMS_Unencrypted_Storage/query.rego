package Cx


CxPolicy [ result  ] { #Resource Type DB  and StorageEncrypted is False

  document := input.document[i]
  resource := document.Resources[key]
  isDBType(resource.Type,false)
  properties := resource.Properties
  properties.StorageEncrypted == false
   
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.properties;", [key]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("Resources.%s.properties.StorageEncrypted should be true",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.StorageEncrypted is false",[key])
              }
}

## Particular Case for RedShift ## 
CxPolicy [ result  ] {  #Resource Type DB RedShift and Encrypted is False

  document := input.document[i]
  resource := document.Resources[key]
  contains(resource.Type,"Redshift")
  properties := resource.Properties
  properties.Encrypted == false
   
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.properties;", [key]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("Resources.%s.properties.Encrypted should be true",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.Encrypted is false",[key])
              }
}
CxPolicy [ result ]  {  #Resource Type DB RedShift and Encrypted is undefined

  document := input.document[i]
  resource := document.Resources[key]
  contains(resource.Type,"Redshift")
  properties := resource.Properties
  object.get( properties ,"Encrypted", "undefined") == "undefined"
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("resources.%s.properties;", [key]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.properties.Encrypted should be defined",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.Encrypted is undefined",[key])
              }
}

## Particular Case for RedShift ## 

CxPolicy [ result ] { #Resource Type Any DB and KmsKeyId is undefined

  document := input.document[i]
  resource := document.Resources[key]
  isDBType(resource.Type, true)
  properties := resource.Properties
  object.get( properties ,"KmsKeyId", "undefined") == "undefined"
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("resources.%s.properties;", [key]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.properties.KmsKeyId should be defined with AWS-Managed CMK",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.KmsKeyId is undefined",[key])
              }
}
CxPolicy [ result ] { #Resource with name containing DB and KmsKeyId is undefined

  document := input.document[i]
  resource := document.Resources[key]
  not isDBType(resource.Type, true)
  isDBName(key)
  properties := resource.Properties
  object.get( properties ,"KmsKeyId", "undefined") == "undefined"
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("resources.%s.properties;", [key]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.properties.KmsKeyId should be defined with AWS-Managed CMK",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.KmsKeyId is undefined",[key])
              }
}


CxPolicy [ result ] { # DBTypes any DB, but without storage encrypted is undefined

  document := input.document[i]
  resource := document.Resources[key]
  isDBType(resource.Type,false)
  
  properties := resource.Properties
  object.get( properties ,"StorageEncrypted", "undefined") == "undefined"
   
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("resources.%s.properties;", [key]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.properties.StorageEncrypted should be defined",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.StorageEncrypted is undefined",[key])
              }
}



CxPolicy [ result ] {

  document := input.document[i]
  resource := document.Resources[key]
  isDBName(key)
  properties := resource.Properties
  object.get( properties ,"StorageEncrypted", "undefined") == "undefined"
   
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("resources.%s.properties;", [key]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.properties.StorageEncrypted should be defined",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.StorageEncrypted is undefined",[key])
              }
}


CxPolicy [ result  ] {

  document := input.document[i]
  resource := document.Resources[key]
  isDBType(resource.Type,false)
  properties := resource.Properties
  properties.StorageEncrypted == false
   
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.properties;", [key]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("Resources.%s.properties.StorageEncrypted should be true",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.StorageEncrypted is false",[key])
              }
}


CxPolicy [ result ] {

  document := input.document[i]
  resource := document.Resources[key]
  isDBType(resource.Type,false)
  properties := resource.Properties
  properties.StorageEncrypted == true
  object.get( properties ,"KmsKeyId", "undefined") == "undefined"
   
  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("resources.%s.properties;", [key]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": sprintf("Resources.%s.properties.KmsKeyId should be defined with AWS-Managed CMK",[key]),
                "keyActualValue": 	sprintf("Resources.%s.properties.KmsKeyId is undefined",[key])
              }
}


isDBName(name) = result {
	possibleDBs := {  "couchbase", "riak","redis", "hbase", "Oracle", "SAP Hana", "Postgres", "cassandra", "hadoop", "Mongo", "Neo4j","DB","SQL"}
    result :=  contains(name,possibleDBs[_])
}else{ result:= false}



isDBType(type, particular) = result {
	listDb := {"DBInstance","DBCluster","RDS", "DocDB"}
    result :=  contains(type,listDb[_])
}else {
  result := false
}





