package Cx

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  not metadata.namespace
  kind := resource.kind
  kind == "Pod"
  volumes := resource.spec.volumes
  volumes[_]["hostPath"]
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.volumes.name=%s.hostPath", [metadata.name, volumes[_].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "Ensure pods outside of kube-system do not have access to node volume",
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' should not have hostPath mounted", [resource.metadata.name, kind, "default"])
  } 
}

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  namespace := metadata.namespace
  namespace != "kube-system"
  kind := resource.kind
  kind == "Pod"
  volumes := resource.spec.volumes
  volumes[_]["hostPath"]
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.volumes.name=%s.hostPath", [metadata.name, volumes[_].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "Ensure pods outside of kube-system do not have access to node volume",
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace '%s' should not have hostPath mounted", [resource.metadata.name, kind, namespace])
  } 
}


CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  namespace := metadata.namespace
  namespace != "kube-system"
  kind := resource.kind
  kind != "Pod"
  spec := resource.spec.template.spec
  volumes := spec.volumes
  volumes[_]["hostPath"]
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.template.spec.volumes.name=%s.hostPath", [metadata.name, volumes[_].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "Ensure pods outside of kube-system do not have access to node volume",
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace actual '%s' should not have hostPath mounted", [resource.metadata.name, kind, namespace])
  }
}

CxPolicy [result] {
  resource := input.document[i]
  metadata := resource.metadata
  not metadata.namespace
  kind := resource.kind
  kind != "Pod"
  spec := resource.spec.template.spec
  volumes := spec.volumes
  volumes[_]["hostPath"]
  result := {
    "documentId": input.document[i].id,
    "searchKey": sprintf("metadata.name=%s.spec.template.spec.volumes.name=%s.hostPath", [metadata.name, volumes[_].name]),
    "issueType": "IncorrectValue",
    "keyExpectedValue": "Ensure pods outside of kube-system do not have access to node volume",
    "keyActualValue": sprintf("Resource name '%s' of kind '%s' in a non kube-system namespace actual '%s' should not have hostPath mounted", [resource.metadata.name, kind, "default"])
  }
}
