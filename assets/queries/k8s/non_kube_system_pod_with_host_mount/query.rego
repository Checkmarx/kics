package Cx

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  not metadata.namespace
  resource.kind == "Pod"
  volumes := resource.spec.volumes
  volumes[_].hostPath.path
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.volumes.name=%s.hostPath.path", [metadata.name, volumes[j].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' should not have hostPath '%s' mounted", [
      metadata.name,
      resource.kind,
      "default",
      volumes[j].hostPath.path
    ]),
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' has a hostPath '%s' mounted", [
      metadata.name,
      resource.kind,
      "default",
      volumes[j].hostPath.path
    ])
  } 
}

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  namespace := metadata.namespace
  namespace != "kube-system"
  resource.kind == "Pod"
  volumes := resource.spec.volumes
  volumes[_].hostPath.path
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.volumes.name=%s.hostPath.path", [metadata.name, volumes[j].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' should not have hostPath '%s' mounted", [
      metadata.name,
      resource.kind,
      metadata.namespace,
      volumes[j].hostPath.path
    ]),
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' has a hostPath '%s' mounted", [
      metadata.name,
      resource.kind,
      metadata.namespace,
      volumes[j].hostPath.path
    ])
  } 
}


CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  namespace := metadata.namespace
  namespace != "kube-system"
  resource.kind != "Pod"
  volumes := resource.spec.template.spec.volumes
  volumes[_].hostPath.path
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.template.spec.volumes.name=%s.hostPath.path", [metadata.name, volumes[j].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' should not have hostPath '%s' mounted", [
      metadata.name,
      resource.kind,
      "default",
      volumes[j].hostPath.path
    ]),
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in non kube-system namespace '%s' has a hostPath '%s' mounted", [
      metadata.name,
      resource.kind,
      "default",
      volumes[j].hostPath.path
    ])
  }
}

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  not metadata.namespace
  resource.kind != "Pod"
  volumes := resource.spec.template.spec.volumes
  volumes[_].hostPath.path
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.template.spec.volumes.name=%s.hostPath.path", [metadata.name, volumes[j].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' should not have hostPath '%s' mounted", [
      metadata.name,
      resource.kind,
      "default",
      volumes[j].hostPath.path
    ]),
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' has a hostPath '%s' mounted", [
      metadata.name,
      resource.kind,
      "default",
      volumes[j].hostPath.path
    ])
  }
}

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  resource.kind == "PersistentVolume"
  metadata.namespace != "kube-system"
  path := resource.spec.hostPath.path
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.hostPath.path", [metadata.name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("PersistentVolume name '%s' of kind '%s' in non kube-system namespace '%s' should not mount a host sensitive OS directory '%s' with hostPath", [
      metadata.name,
      resource.kind,
      metadata.namespace,
      path
    ]),
    "keyActualValue": sprintf("PersistentVolume name '%s' of kind '%s' in non kube-system namespace '%s' is mounting a host sensitive OS directory '%s' with hostPath", [
      metadata.name,
      resource.kind,
      metadata.namespace,
      path
    ])
  }
}

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  resource.kind == "PersistentVolume"
  not metadata.namespace
  path := resource.spec.hostPath.path
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.hostPath.path", [metadata.name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": sprintf("PersistentVolume name '%s' of kind '%s' in non kube-system namespace '%s' should not mount a host sensitive OS directory '%s' with hostPath", [
      metadata.name,
      resource.kind,
      "default",
      path
    ]),
    "keyActualValue": sprintf("PersistentVolume name '%s' of kind '%s' in non kube-system namespace '%s' is mounting a host sensitive OS directory '%s' with hostPath", [
      metadata.name,
      resource.kind,
      "default",
      path
    ])
  }
}
