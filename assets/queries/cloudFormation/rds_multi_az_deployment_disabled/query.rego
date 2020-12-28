package Cx

CxPolicy [result] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::RDS::DBInstance"
  properties := resource.Properties
  properties.MultiAZ == false

  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s.Properties.MultiAZ", [name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [name]),
    "keyActualValue": sprintf("The RDS DBInstance '%s' has MultiAZ value set to false", [name])
  }
}

CxPolicy [result] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::RDS::DBInstance"
  properties := resource.Properties
  object.get(properties, "MultiAZ", "undefined") == "undefined"

  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s", [name]),
    "issueType": "MissingAttribute",
    "keyExpectedValue": sprintf("The RDS DBInstance '%s' should have Multi-Availability Zone enabled", [name]),
    "keyActualValue": sprintf("The RDS DBInstance '%s' MultiAZ property is undefined and by default disabled", [name])
  }
}
