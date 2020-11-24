package Cx


CxPolicy [ result ] {
  resource := input.document[i].resource.kubernetes_pod[name]
  
  resource.spec.container
  
  not resource.spec.container.read_only_root_filesystem

  
  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("kubernetes_pod[%s].spec.container", [name]),
                "issueType":         "MissingAttribute",
                "keyExpectedValue":  "Attribute 'read_only_root_filesystem' is set and true",
                "keyActualValue":    "Attribute 'read_only_root_filesystem' is undefined or false"
            }
}

