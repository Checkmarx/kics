package Cx

CxPolicy [ result ] {
   resource := input.document[i].resource.kubernetes_pod[name]
   spec := resource.spec
   exists_container := object.get(spec, "container", "undefined") != "undefined"
   exists_container
   
   container := resource.spec.container
   exists_security_context := object.get(container, "security_context", "undefined") != "undefined"
   exists_security_context
   
   security_context := resource.spec.container.security_context
   exists_capabilities := object.get(security_context, "capabilities", "undefined") != "undefined"
   exists_capabilities
   
   capabilities := resource.spec.container.security_context.capabilities
   exists_drop := object.get(capabilities, "drop", "undefined") != "undefined"
   exists_drop
   
   drop := resource.spec.container.security_context.capabilities.drop
   drop == "ALL"
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("kubernetes_pod[%s].spec.container.security_context.capabilities.drop", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("kubernetes_pod[%s].spec.container.security_context.capabilities are not dropped", [name]),
                "keyActualValue": 	sprintf("kubernetes_pod[%s].spec.container.security_context.capabilities are dropped", [name])
              }
}