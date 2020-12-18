package Cx

CxPolicy [ result ] {
  document := input.document[i]
  resource = document.Resources[key]
  resource.Type == "AWS::EFS::FileSystem"
  properties := resource.Properties
  properties.Encrypted == false

  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("Resources.%s.Properties.Encrypted", [key]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("EFS resource '%s' should have encryption enabled", [key]),
    "keyActualValue": sprintf("EFS resource '%s' has encryption set to false", [key]),
  }
}
