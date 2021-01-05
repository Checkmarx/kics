package Cx

CxPolicy [ result ] {
  document := input.document
  resource = document[i].Resources[name]
  resource.Type == "AWS::EC2::Volume"
  properties := resource.Properties
  object.get(properties, "Encrypted", "undefined") == "undefined"

      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted is defined", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.Encrypted is not defined", [name])
              }
}

CxPolicy [ result ] {
  document := input.document
  resource = document[i].Resources[name]
  resource.Type == "AWS::EC2::Volume"
  properties := resource.Properties
  properties.Encrypted == false

      result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("Resources.%s.Properties.Encrypted", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.Encrypted is true", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.Encrypted is false", [name])
              }
}
