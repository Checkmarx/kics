package Cx

CxPolicy [ result ] {
  document := input.document[i]
  resource = document.Resources[name]
  resource.Type == "AWS::Lambda::Function"
  properties := resource.Properties
  properties.TracingConfig.Mode == "PassThrough"

  result := {
    "documentId": document.id,
    "searchKey": sprintf("Resources.%s", [name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "TracingConfig.Mode is set to 'Active'",
    "keyActualValue": "TracingConfig.Mode is set to 'PassThrough'"
  }
}

CxPolicy [ result ] {
  document := input.document[i]
  resource = document.Resources[name]
  resource.Type == "AWS::Lambda::Function"
  properties := resource.Properties
  object.get(properties, "TracingConfig", "undefined") == "undefined"

  result := {
    "documentId": document.id,
    "searchKey": sprintf("Resources.%s", [name]),
    "issueType": "MissingAttribute",
    "keyExpectedValue": "Property 'TracingConfig' is defined",
    "keyActualValue": "Property 'TracingConfig' is undefined"
  }
}