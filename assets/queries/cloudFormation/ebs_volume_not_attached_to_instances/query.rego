package Cx
CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type == "AWS::EC2::Volume"

  not attachedToInstances(name, input.document[i])
    result := {
                "documentId":       input.document[i].id,
                "searchKey":        sprintf("Resources.%s", [name]),
                "issueType":        "MissingAttribute",
                "keyExpectedValue": sprintf("'Resources.%s' is attached to instances", [name]),
                "keyActualValue":   sprintf("'Resources.%s' is not attached to instances", [name])
              }
}
attachedToInstances(volumeName, test) {
    some va
        resource := test.Resources[va]
        resource.Type == "AWS::EC2::VolumeAttachment"
        refers(resource.Properties.VolumeId, volumeName)
}
refers(obj, name) {
    obj.Ref == name
}
refers(obj, name) {
    obj == name
}
