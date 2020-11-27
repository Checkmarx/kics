package Cx

CxPolicy [ result ] {
   resource := input.document[i].resource.kubernetes_pod[name]
   container := resource.spec.container
   not container.privileged 
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("kubernetes_pod[%s].spec.container.privileged", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("kubernetes_pod[%s].spec.container.privileged is true", [name]),
                "keyActualValue": 	sprintf("kubernetes_pod[%s].spec.container.privileged is false", [name])
              }
}