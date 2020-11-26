package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.kubernetes_pod[name]
  
  resource.spec.container.capabilities.add

  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("kubernetes_pod[%s].spec.container.capabilities.add", [name]),
                "issueType":         "IncorrectValue",
                "keyExpectedValue":  "Attribute 'add' is undefined",
                "keyActualValue":    "Attribute 'add' is set"
            }
}