package Cx

CxPolicy [ result ] {
  document := input.document[i]
  resource = document.Resources[name]
  resource.Type == "AWS::EFS::FileSystem"
  properties := resource.Properties
  object.get(properties, "FileSystemTags", "undefined") == "undefined"

  result := {
    "documentId": document.id,
    "searchKey": sprintf("Resources.%s", [name]),
    "issueType": "MissingAttribute",
    "keyExpectedValue": sprintf("EFS resource '%s' should have file system tags associated", [name]),
    "keyActualValue": sprintf("EFS resource '%s' doesn't have any file system tags associated", [name]),
  }
}
