package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.kubernetes_pod[name]
  
  container := resource.spec.container
  
  object.get(container, "read_only_root_filesystem", "undefined") == "undefined"

  
  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("kubernetes_pod[%s].spec.container", [name]),
                "issueType":         "MissingAttribute",
                "keyExpectedValue":  "Attribute 'read_only_root_filesystem' is set",
                "keyActualValue":    "Attribute 'read_only_root_filesystem' is undefined"
            }
}


CxPolicy [ result ] {
  resource := input.document[i].resource.kubernetes_pod[name]
  
  container := resource.spec.container
  
  container.read_only_root_filesystem == false

  
  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("kubernetes_pod[%s].spec.container.read_only_root_filesystem", [name]),
                "issueType":         "IncorrectValue",
                "keyExpectedValue":  "Attribute 'read_only_root_filesystem' is true",
                "keyActualValue":    "Attribute 'read_only_root_filesystem' is false"
            }
}

