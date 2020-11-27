package Cx

CxPolicy [ result ] {
   resource := input.document[i].resource.kubernetes_pod_security_policy[name]
   spec := resource.spec
   requiredDropCapabilities := object.get(spec, "requiredDropCapabilities", "undefined") != "undefined"
   requiredDropCapabilities
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("kubernetes_pod_security_policy[%s].spec.requiredDropCapabilities", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.requiredDropCapabilities is undefined", [name]),
                "keyActualValue": 	sprintf("kubernetes_pod_security_policy[%s].spec.requiredDropCapabilities is defined", [name])
              }
}