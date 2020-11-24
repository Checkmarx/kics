package Cx


CxPolicy [ result ] {
  resource := input.document[i].resource.kubernetes_pod[name]
  
  container := resource.spec.container
  
  not container.read_only_root_filesystem

  
  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("resource.aws_iam_user_policy[%s].resource.kubernetes_pod.spec.container", [name]),
                "issueType":         "MissingAttribute",
                "keyExpectedValue":  "Attribute 'read_only_root_filesystem' is set and true",
                "keyActualValue":    "Attribute 'read_only_root_filesystem' is undefined or false"
            }
}

