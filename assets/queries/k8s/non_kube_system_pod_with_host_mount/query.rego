package Cx

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  not metadata.namespace
  resource.kind == "Pod"
  volumes := resource.spec.volumes
  volumes[_]["hostPath"]
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.volumes.name=%s.hostPath", [metadata.name, volumes[_].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' should not have hostPath mounted", [resource.metadata.name, resource.kind, "default"]),
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' has a hostPath mounted", [resource.metadata.name, resource.kind, "default"])
  } 
}

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  namespace := metadata.namespace
  namespace != "kube-system"
  resource.kind == "Pod"
  volumes := resource.spec.volumes
  volumes[_]["hostPath"]
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.volumes.name=%s.hostPath", [metadata.name, volumes[_].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' should not have hostPath mounted", [resource.metadata.name, resource.kind, "default"]),
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' has a hostPath mounted", [resource.metadata.name, resource.kind, "default"])
  } 
}


CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  namespace := metadata.namespace
  namespace != "kube-system"
  resource.kind != "Pod"
  spec := resource.spec.template.spec
  volumes := spec.volumes
  volumes[_]["hostPath"]
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.template.spec.volumes.name=%s.hostPath", [metadata.name, volumes[_].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' should not have hostPath mounted", [resource.metadata.name, resource.kind, "default"]),
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' has a hostPath mounted", [resource.metadata.name, resource.kind, "default"])
  }
}

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  not metadata.namespace
  resource.kind != "Pod"
  spec := resource.spec.template.spec
  volumes := spec.volumes
  volumes[_]["hostPath"]
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.template.spec.volumes.name=%s.hostPath", [metadata.name, volumes[_].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' should not have hostPath mounted", [resource.metadata.name, resource.kind, "default"]),
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' has a hostPath mounted", [resource.metadata.name, resource.kind, "default"])
  }
}
