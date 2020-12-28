package Cx

CxPolicy [ result ] {
  document := input.document
  resource = document[i].Resources[name]
  resource.Type == "AWS::Elasticsearch::Domain"
  properties := resource.Properties

  object.get(properties, "EncryptionAtRestOptions", "undefined") == "undefined"

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

  properties.EncryptionAtRestOptions.Enabled != true

      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.EncryptionAtRestOptions", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.EncryptionAtRestOptions is enabled", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.EncryptionAtRestOptions is disabled", [name])
              }
}
