package Cx


CxPolicy [ result ] {
  resource := input.document[i].resource.kubernetes_pod[name]
  
  container := resource.spec.container
  
  not container.resources

  
  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("resource.aws_iam_user_policy[%s].resource.kubernetes_pod.spec.container", [name]),
                "issueType":         "MissingAttribute",
                "keyExpectedValue":  "Attribute 'resources' is set",
                "keyActualValue":    "Attribute 'resources' is undefined"
            }
}



CxPolicy [ result ] {
  resource := input.document[i].resource.kubernetes_pod[name]
  
  container := resource.spec.container
  
  not container.resources.limits

  
  result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("resource.aws_iam_user_policy[%s].resource.kubernetes_pod.spec.container.resources", [name]),
                "issueType":         "MissingAttribute",
                "keyExpectedValue":  "Attribute 'container' has resource limitations defined",
                "keyActualValue":    "Attribute 'container' does not have resource limitations defined"
            }
}