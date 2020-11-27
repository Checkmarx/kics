package Cx

CxPolicy [ result ] {
   resource := input.document[i].resource.kubernetes_pod_security_policy[name]
   spec := resource.spec
   not spec.privileged 
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("kubernetes_pod_security_policy[%s].spec.privileged", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.privileged is true", [name]),
                "keyActualValue": 	sprintf("kubernetes_pod_security_policy[%s].spec.privileged is false", [name])
              }
}