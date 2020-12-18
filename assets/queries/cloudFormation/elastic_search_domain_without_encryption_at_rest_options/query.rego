package Cx

CxPolicy [ result ] {
  document := input.document
  resource = document[i].Resources[name]
  resource.Type == "AWS::Elasticsearch::Domain"
  properties := resource.Properties
  
  exists_encryptionAtRestOptions := object.get(properties, "EncryptionAtRestOptions", "undefined") != "undefined"
  not exists_encryptionAtRestOptions
  
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.EncryptionAtRestOptions", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions is defined", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.EncryptionAtRestOptions is undefined", [name])
              }
}

CxPolicy [ result ] {
  document := input.document
  resource = document[i].Resources[name]
  resource.Type == "AWS::Elasticsearch::Domain"
  properties := resource.Properties
  
  checks_encryption_at_rest_options(properties.EncryptionAtRestOptions)
  
      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.EncryptionAtRestOptions", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions is enabled", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.EncryptionAtRestOptions is disabled", [name])
              }
}

checks_encryption_at_rest_options(encryptionAtRestOptions) {
	encryptionAtRestOptions.Enabled != true
}
